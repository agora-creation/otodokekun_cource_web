import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_invoice.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_invoice.dart';
import 'package:otodokekun_cource_web/screens/invoice_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class InvoiceScreen extends StatelessWidget {
  static const String id = 'invoice';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopInvoiceProvider = Provider.of<ShopInvoiceProvider>(context);
    final Stream<QuerySnapshot> streamInvoice = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('invoice')
        .orderBy('openedAt', descending: true)
        .snapshots();
    List<Map<String, dynamic>> _source = [];

    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamInvoice,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _source.clear();
            for (DocumentSnapshot invoice in snapshot.data.docs) {
              ShopInvoiceModel shopInvoiceModel =
                  ShopInvoiceModel.fromSnapshot(invoice);
              _source.add(shopInvoiceModel.toMap());
            }
          }
          return InvoiceTable(
            shop: shopProvider.shop,
            shopInvoiceProvider: shopInvoiceProvider,
            source: _source,
          );
        },
      ),
    );
  }
}
