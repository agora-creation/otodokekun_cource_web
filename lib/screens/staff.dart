import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/screens/staff_table.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_admin_scaffold.dart';

class StaffScreen extends StatelessWidget {
  static const String id = 'staff';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopStaffProvider = Provider.of<ShopStaffProvider>(context);
    final Stream<QuerySnapshot> streamStaff = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('staff')
        .orderBy('createdAt', descending: true)
        .snapshots();
    List<Map<String, dynamic>> _source = [];
    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamStaff,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _source.clear();
            for (DocumentSnapshot staff in snapshot.data.docs) {
              ShopStaffModel shopStaffModel =
                  ShopStaffModel.fromSnapshot(staff);
              _source.add(shopStaffModel.toMap());
            }
          }
          return StaffTable(
            shop: shopProvider.shop,
            shopStaffProvider: shopStaffProvider,
            source: _source,
          );
        },
      ),
    );
  }
}
