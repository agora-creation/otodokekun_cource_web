import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_course.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_course.dart';
import 'package:otodokekun_cource_web/providers/shop_product.dart';
import 'package:otodokekun_cource_web/screens/course_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class CourseScreen extends StatelessWidget {
  static const String id = 'course';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopCourseProvider = Provider.of<ShopCourseProvider>(context);
    final shopProductProvider = Provider.of<ShopProductProvider>(context);
    final Stream<QuerySnapshot> streamCourse = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('course')
        .orderBy('createdAt', descending: true)
        .snapshots();
    List<Map<String, dynamic>> _source = [];
    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamCourse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _source.clear();
            for (DocumentSnapshot course in snapshot.data.docs) {
              ShopCourseModel shopCourseModel =
                  ShopCourseModel.fromSnapshot(course);
              _source.add(shopCourseModel.toMap());
            }
          }
          return CourseTable(
            shop: shopProvider.shop,
            shopCourseProvider: shopCourseProvider,
            shopProductProvider: shopProductProvider,
            source: _source,
          );
        },
      ),
    );
  }
}
