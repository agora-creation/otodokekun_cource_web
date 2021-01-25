import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/login.dart';
import 'package:otodokekun_cource_web/widgets/border_round_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const String id = 'user';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    return CustomAdminScaffold(
      title: shopProvider.shop?.name ?? '',
      actions: [
        IconButton(
          icon: Icon(Icons.store),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('店舗情報'),
                  actions: [
                    BorderRoundButton(
                      labelText: 'ログアウト',
                      labelColor: Colors.blueAccent,
                      borderColor: Colors.blueAccent,
                      onTap: () {
                        shopProvider.signOut();
                        shopProvider.clearController();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
      selectedRoute: id,
      body: Container(),
    );
  }
}
