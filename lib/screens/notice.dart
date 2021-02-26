import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_notice.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_notice.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/providers/user_notice.dart';
import 'package:otodokekun_cource_web/screens/notice_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatelessWidget {
  static const String id = 'notice';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopNoticeProvider = Provider.of<ShopNoticeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userNoticeProvider = Provider.of<UserNoticeProvider>(context);
    final Stream<QuerySnapshot> streamNotice = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('notice')
        .orderBy('createdAt', descending: true)
        .snapshots();
    List<Map<String, dynamic>> _source = [];

    return CustomAdminScaffold(
      shopProvider: shopProvider,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamNotice,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _source.clear();
            for (DocumentSnapshot notice in snapshot.data.docs) {
              ShopNoticeModel shopNoticeModel =
                  ShopNoticeModel.fromSnapshot(notice);
              _source.add(shopNoticeModel.toMap());
            }
          }
          return NoticeTable(
            shop: shopProvider.shop,
            shopNoticeProvider: shopNoticeProvider,
            userProvider: userProvider,
            userNoticeProvider: userNoticeProvider,
            source: _source,
          );
        },
      ),
    );
  }
}
