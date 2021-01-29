import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/screens/user_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const String id = 'user';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: UserTable(
        shopProvider: shopProvider,
        userProvider: userProvider,
      ),
    );
  }
}
