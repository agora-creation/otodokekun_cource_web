import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:otodokekun_cource_web/helpers/side_menu.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/login.dart';
import 'package:otodokekun_cource_web/widgets/border_round_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';

class CustomAdminScaffold extends StatelessWidget {
  final ShopProvider shopProvider;
  final String selectedRoute;
  final Widget body;

  CustomAdminScaffold({
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
              shopProvider.clearController();
              shopProvider.name.text = shopProvider.shop?.name;
              shopProvider.zip.text = shopProvider.shop?.zip;
              shopProvider.address.text = shopProvider.shop?.address;
              shopProvider.tel.text = shopProvider.shop?.tel;
              shopProvider.email.text = shopProvider.shop?.email;
              shopProvider.staff.text = shopProvider.shop?.staff;
              shopProvider.cancelLimit = shopProvider.shop?.cancelLimit;
              showDialog(
                context: context,
                builder: (_) {
                  return ShopCustomDialog(shopProvider: shopProvider);
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
            child: Text('お届けくん(BtoC)', style: TextStyle(color: Colors.white)),
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
              constraints: BoxConstraints(maxHeight: 700.0),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
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

class ShopCustomDialog extends StatefulWidget {
  final ShopProvider shopProvider;

  ShopCustomDialog({@required this.shopProvider});

  @override
  _ShopCustomDialogState createState() => _ShopCustomDialogState();
}

class _ShopCustomDialogState extends State<ShopCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '店舗情報',
      content: Container(
        width: 400.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: widget.shopProvider.name,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: '店舗名',
              iconData: Icons.store,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProvider.zip,
              obscureText: false,
              textInputType: TextInputType.number,
              maxLines: 1,
              labelText: '郵便番号',
              iconData: Icons.location_pin,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProvider.address,
              obscureText: false,
              textInputType: TextInputType.streetAddress,
              maxLines: 1,
              labelText: '住所',
              iconData: Icons.business,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProvider.tel,
              obscureText: false,
              textInputType: TextInputType.phone,
              maxLines: 1,
              labelText: '電話番号',
              iconData: Icons.phone,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProvider.email,
              obscureText: false,
              textInputType: TextInputType.emailAddress,
              maxLines: 1,
              labelText: 'メールアドレス',
              iconData: Icons.email,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProvider.staff,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: '担当者名',
              iconData: Icons.person,
            ),
            SizedBox(height: 8.0),
            DropdownButton<int>(
              isExpanded: true,
              value: widget.shopProvider.cancelLimit,
              onChanged: (value) {
                setState(() {
                  widget.shopProvider.cancelLimit = value;
                });
              },
              items: widget.shopProvider.cancelLimitList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text('注文のキャンセルは$value日前まで可能'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        BorderRoundButton(
          labelText: 'ログアウト',
          labelColor: Colors.blueAccent,
          borderColor: Colors.blueAccent,
          onTap: () {
            widget.shopProvider.signOut();
            widget.shopProvider.clearController();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
        FillRoundButton(
          labelText: '変更を保存',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopProvider.updateShop()) {
              return;
            }
            widget.shopProvider.clearController();
            widget.shopProvider.reloadShopModel();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
