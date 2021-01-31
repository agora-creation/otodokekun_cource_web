import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_product.dart';
import 'package:otodokekun_cource_web/screens/product_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopProductProvider = Provider.of<ShopProductProvider>(context);
    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: ProductTable(
        shopProvider: shopProvider,
        shopProductProvider: shopProductProvider,
      ),
    );
  }
}
