import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:otodokekun_cource_web/helpers/side_menu.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/app.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/login.dart';
import 'package:otodokekun_cource_web/widgets/border_round_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';

class CustomAdminScaffold extends StatelessWidget {
  final AppProvider appProvider;
  final ShopProvider shopProvider;
  final String selectedRoute;
  final Widget body;

  CustomAdminScaffold({
    this.appProvider,
    this.shopProvider,
    this.selectedRoute,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          shopProvider.shop?.name ?? '',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.store),
            onPressed: () {
              shopProvider.setController();
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '店舗情報',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    content: appProvider.isLoading
                        ? LoadingWidget()
                        : Container(
                            width: 350.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  controller: shopProvider.name,
                                  obscureText: false,
                                  labelText: '店舗名',
                                  iconData: Icons.store,
                                ),
                                SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: shopProvider.zip,
                                  obscureText: false,
                                  labelText: '郵便番号',
                                  iconData: Icons.location_pin,
                                ),
                                SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: shopProvider.address,
                                  obscureText: false,
                                  labelText: '住所',
                                  iconData: Icons.business,
                                ),
                                SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: shopProvider.tel,
                                  obscureText: false,
                                  labelText: '電話番号',
                                  iconData: Icons.phone,
                                ),
                                SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: shopProvider.staff,
                                  obscureText: false,
                                  labelText: '担当者名',
                                  iconData: Icons.person,
                                ),
                              ],
                            ),
                          ),
                    contentPadding: EdgeInsets.all(16.0),
                    actions: [
                      appProvider.isLoading
                          ? Container()
                          : BorderRoundButton(
                              labelText: 'ログアウト',
                              labelColor: Colors.blueAccent,
                              borderColor: Colors.blueAccent,
                              onTap: () {
                                appProvider.changeLoading();
                                shopProvider.signOut();
                                shopProvider.clearController();
                                appProvider.changeLoading();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                            ),
                      appProvider.isLoading
                          ? Container()
                          : FillRoundButton(
                              labelText: '変更を保存',
                              labelColor: Colors.white,
                              backgroundColor: Colors.blueAccent,
                              onTap: () async {
                                appProvider.changeLoading();
                                if (!await shopProvider.updateShop()) {
                                  appProvider.changeLoading();
                                  return;
                                }
                                shopProvider.clearController();
                                shopProvider.reloadShopModel();
                                appProvider.changeLoading();
                                Navigator.pop(context);
                              },
                            ),
                    ],
                    actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  );
                },
              );
            },
          ),
        ],
      ),
      sideBar: SideBar(
        activeIconColor: Colors.white,
        activeTextStyle: TextStyle(color: Colors.white),
        activeBackgroundColor: kSubColor.withOpacity(0.8),
        textStyle: TextStyle(color: kSubColor),
        items: kSideMenu,
        selectedRoute: selectedRoute,
        onSelected: (item) {
          Navigator.pushNamed(context, item.route);
        },
        footer: Container(
          height: 50.0,
          width: double.infinity,
          color: kMainColor.withOpacity(0.5),
          child: Center(
            child: Text('お届けくん(期間配達)', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(0.0),
              child: Card(
                elevation: 1.0,
                clipBehavior: Clip.none,
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}