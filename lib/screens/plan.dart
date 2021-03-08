import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_plan.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop_plan.dart';
import 'package:otodokekun_cource_web/screens/plan_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatelessWidget {
  static const String id = 'plan';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final shopPlanProvider = Provider.of<ShopPlanProvider>(context);
    final Stream<QuerySnapshot> streamPlan = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('plan')
        .orderBy('deliveryAt', descending: false)
        .snapshots();
    List<Map<String, dynamic>> _source = [];

    return CustomAdminScaffold(
      shopProvider: shopProvider,
      shopOrderProvider: shopOrderProvider,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamPlan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _source.clear();
            for (DocumentSnapshot plan in snapshot.data.docs) {
              ShopPlanModel shopPlanModel = ShopPlanModel.fromSnapshot(plan);
              _source.add(shopPlanModel.toMap());
            }
          }
          return PlanTable(
            shop: shopProvider.shop,
            shopPlanProvider: shopPlanProvider,
            source: _source,
          );
        },
      ),
    );
  }
}
