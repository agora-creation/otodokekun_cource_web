import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_course.dart';
import 'package:otodokekun_cource_web/screens/course_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class CourseScreen extends StatelessWidget {
  static const String id = 'course';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopCourseProvider = Provider.of<ShopCourseProvider>(context);
    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: CourseTable(
        shop: shopProvider.shop,
        shopCourseProvider: shopCourseProvider,
      ),
    );
  }
}
