import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:otodokekun_cource_web/helpers/side_menu.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/screens/shop.dart';

class CustomAdminScaffold extends StatelessWidget {
  final ShopModel shop;
  final String selectedRoute;
  final Widget body;

  CustomAdminScaffold({
    @required this.shop,
    @required this.selectedRoute,
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          shop?.name ?? '',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, ShopScreen.id),
            icon: Icon(Icons.store),
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
              constraints: BoxConstraints(maxHeight: 750.0),
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
