import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_notice.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop_plan.dart';
import 'package:otodokekun_cource_web/providers/shop_product.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/providers/user_notice.dart';
import 'package:otodokekun_cource_web/screens/login.dart';
import 'package:otodokekun_cource_web/screens/notice.dart';
import 'package:otodokekun_cource_web/screens/order.dart';
import 'package:otodokekun_cource_web/screens/plan.dart';
import 'package:otodokekun_cource_web/screens/product.dart';
import 'package:otodokekun_cource_web/screens/registration.dart';
import 'package:otodokekun_cource_web/screens/splash.dart';
import 'package:otodokekun_cource_web/screens/staff.dart';
import 'package:otodokekun_cource_web/screens/user.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  if (FirebaseAuth.instance.currentUser == null) {
    await Future.any([
      FirebaseAuth.instance.userChanges().firstWhere((u) => u != null),
      Future.delayed(Duration(milliseconds: 2000)),
    ]);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ShopProvider.initialize()),
        ChangeNotifierProvider.value(value: ShopNoticeProvider()),
        ChangeNotifierProvider.value(value: ShopOrderProvider()),
        ChangeNotifierProvider.value(value: ShopPlanProvider()),
        ChangeNotifierProvider.value(value: ShopProductProvider()),
        ChangeNotifierProvider.value(value: ShopStaffProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: UserNoticeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ja'),
        ],
        title: 'お届けくん(BtoC)',
        theme: theme(),
        home: SplashController(),
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          NoticeScreen.id: (context) => NoticeScreen(),
          OrderScreen.id: (context) => OrderScreen(),
          PlanScreen.id: (context) => PlanScreen(),
          ProductScreen.id: (context) => ProductScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          StaffScreen.id: (context) => StaffScreen(),
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
        return OrderScreen();
      default:
        return LoginScreen();
    }
  }
}
