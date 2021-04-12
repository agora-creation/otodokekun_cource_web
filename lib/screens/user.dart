import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/user_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const String id = 'user';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final Stream<QuerySnapshot> streamUser = FirebaseFirestore.instance
        .collection('user')
        .where('shopId', isEqualTo: shopProvider.shop?.id)
        .orderBy('createdAt', descending: true)
        .snapshots();
    List<UserModel> _users = [];

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _users.clear();
            for (DocumentSnapshot user in snapshot.data.docs) {
              _users.add(UserModel.fromSnapshot(user));
            }
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: kSubColor),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('顧客', style: TextStyle(fontSize: 18.0)),
                        Container(),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text('顧客の情報を見ることができます。顧客はスマホアプリのご利用者です。'),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: UserTable(users: _users),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return LoadingWidget();
          }
        },
      ),
    );
  }
}
