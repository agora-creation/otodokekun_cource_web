import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/order_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const String id = 'order';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: OrderTable(shopProvider: shopProvider),
    );
  }
}
