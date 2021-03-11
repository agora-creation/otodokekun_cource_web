import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_invoice.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/screens/order_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const String id = 'order';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopInvoiceProvider = Provider.of<ShopInvoiceProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final shopStaffProvider = Provider.of<ShopStaffProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    String _opened;
    String _closed;
    if (shopOrderProvider.searchDeliveryAtDisabled) {
      _opened = shopOrderProvider.searchOpenedAt.toString();
      _closed = shopOrderProvider.searchClosedAt.toString();
    } else {
      _opened = shopOrderProvider.searchDeliveryAt
          .subtract(Duration(days: 1))
          .toString();
      _closed = shopOrderProvider.searchDeliveryAt.toString();
    }
    final _startAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(_closed).millisecondsSinceEpoch);
    final _endAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(_opened).millisecondsSinceEpoch);
    Stream<QuerySnapshot> _streamOrder;
    if (shopOrderProvider.searchName != '' &&
        shopOrderProvider.searchStaff != '') {
      _streamOrder = FirebaseFirestore.instance
          .collection('shop')
          .doc(shopProvider.shop?.id)
          .collection('order')
          .where('shipping', isEqualTo: shopOrderProvider.searchShipping)
          .where('name', isEqualTo: shopOrderProvider.searchName)
          .where('staff', isEqualTo: shopOrderProvider.searchStaff)
          .orderBy('deliveryAt', descending: true)
          .startAt([_startAt]).endAt([_endAt]).snapshots();
    } else if (shopOrderProvider.searchName != '' &&
        shopOrderProvider.searchStaff == '') {
      _streamOrder = FirebaseFirestore.instance
          .collection('shop')
          .doc(shopProvider.shop?.id)
          .collection('order')
          .where('shipping', isEqualTo: shopOrderProvider.searchShipping)
          .where('name', isEqualTo: shopOrderProvider.searchName)
          .orderBy('deliveryAt', descending: true)
          .startAt([_startAt]).endAt([_endAt]).snapshots();
    } else if (shopOrderProvider.searchName == '' &&
        shopOrderProvider.searchStaff != '') {
      _streamOrder = FirebaseFirestore.instance
          .collection('shop')
          .doc(shopProvider.shop?.id)
          .collection('order')
          .where('shipping', isEqualTo: shopOrderProvider.searchShipping)
          .where('staff', isEqualTo: shopOrderProvider.searchStaff)
          .orderBy('deliveryAt', descending: true)
          .startAt([_startAt]).endAt([_endAt]).snapshots();
    } else {
      _streamOrder = FirebaseFirestore.instance
          .collection('shop')
          .doc(shopProvider.shop?.id)
          .collection('order')
          .where('shipping', isEqualTo: shopOrderProvider.searchShipping)
          .orderBy('deliveryAt', descending: true)
          .startAt([_startAt]).endAt([_endAt]).snapshots();
    }
    List<Map<String, dynamic>> _source = [];

    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamOrder,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _source.clear();
            for (DocumentSnapshot order in snapshot.data.docs) {
              ShopOrderModel shopOrderModel =
                  ShopOrderModel.fromSnapshot(order);
              _source.add(shopOrderModel.toMap());
            }
          }
          return OrderTable(
            shop: shopProvider.shop,
            shopInvoiceProvider: shopInvoiceProvider,
            shopOrderProvider: shopOrderProvider,
            shopStaffProvider: shopStaffProvider,
            userProvider: userProvider,
            source: _source,
          );
        },
      ),
    );
  }
}
