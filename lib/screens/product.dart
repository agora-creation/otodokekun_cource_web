import 'package:cloud_firestore/cloud_firestore.dart';
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
    final Stream<QuerySnapshot> streamProduct = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('product')
        .orderBy('createdAt', descending: true)
        .snapshots();
    List<Map<String, dynamic>> _source = [];

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamProduct,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _source.clear();
          }
          return ProductTable(
            shop: shopProvider.shop,
            shopProductProvider: shopProductProvider,
            source: _source,
          );
        },
      ),
    );
  }
}
