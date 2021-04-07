import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatelessWidget {
  static const String id = 'shop';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kSubColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('店舗情報', style: TextStyle(fontSize: 18.0)),
                  Row(
                    children: [
                      BorderBoxButton(
                        iconData: Icons.exit_to_app,
                        labelText: 'ログアウト',
                        labelColor: Colors.redAccent,
                        borderColor: Colors.redAccent,
                        onTap: () {},
                      ),
                      SizedBox(width: 4.0),
                      FillBoxButton(
                        iconData: Icons.check,
                        labelText: '保存する',
                        labelColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Text('店舗情報を登録できます。この情報はお客様へ公開されます。'),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
