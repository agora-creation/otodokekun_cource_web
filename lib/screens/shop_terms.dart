import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/shop_terms_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class ShopTermsScreen extends StatelessWidget {
  static const String id = 'shop_terms';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return CustomAdminScaffold(
      shop: shopProvider.shop,
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
                  Text('利用規約', style: TextStyle(fontSize: 18.0)),
                  Container(),
                ],
              ),
              SizedBox(height: 4.0),
              Text('この利用規約は顧客が商品を注文する際に表示されます。'),
              SizedBox(height: 8.0),
              Expanded(
                child: ShopTermsTable(
                  shop: shopProvider.shop,
                  shopProvider: shopProvider,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
