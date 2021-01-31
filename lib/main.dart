import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_course.dart';
import 'package:otodokekun_cource_web/providers/shop_notice.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop_product.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/screens/course.dart';
import 'package:otodokekun_cource_web/screens/login.dart';
import 'package:otodokekun_cource_web/screens/notice.dart';
import 'package:otodokekun_cource_web/screens/order.dart';
import 'package:otodokekun_cource_web/screens/product.dart';
import 'package:otodokekun_cource_web/screens/splash.dart';
import 'package:otodokekun_cource_web/screens/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ShopProvider.initialize()),
        ChangeNotifierProvider.value(value: ShopCourseProvider()),
        ChangeNotifierProvider.value(value: ShopNoticeProvider()),
        ChangeNotifierProvider.value(value: ShopOrderProvider()),
        ChangeNotifierProvider.value(value: ShopProductProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'お届けくん(期間配達)',
        theme: theme(),
        home: SplashController(),
        routes: {
          CourseScreen.id: (context) => CourseScreen(),
          NoticeScreen.id: (context) => NoticeScreen(),
          OrderScreen.id: (context) => OrderScreen(),
          ProductScreen.id: (context) => ProductScreen(),
          UserScreen.id: (context) => UserScreen(),
        },
      ),
    );
  }
}

class SplashController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    switch (shopProvider.status) {
      case Status.Uninitialized:
        return SplashScreen();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginScreen();
      case Status.Authenticated:
        return NoticeScreen();
      default:
        return LoginScreen();
    }
  }
}
