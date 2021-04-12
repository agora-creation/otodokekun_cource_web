import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_notice.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_notice.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/providers/user_notice.dart';
import 'package:otodokekun_cource_web/screens/notice_table.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
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
    List<ShopNoticeModel> _notices = [];

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamNotice,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _notices.clear();
            for (DocumentSnapshot notice in snapshot.data.docs) {
              _notices.add(ShopNoticeModel.fromSnapshot(notice));
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
                        Text('お知らせ(通知)', style: TextStyle(fontSize: 18.0)),
                        FillBoxButton(
                          iconData: Icons.add,
                          labelText: '新規登録',
                          labelColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onTap: () {
                            shopNoticeProvider.clearController();
                            showDialog(
                              context: context,
                              builder: (_) => AddNoticeDialog(
                                shop: shopProvider.shop,
                                shopNoticeProvider: shopNoticeProvider,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text('顧客へのお知らせを登録・送信できます。お知らせ内容を登録し、顧客を選んで送信してください。'),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: NoticeTable(
                        shopNoticeProvider: shopNoticeProvider,
                        userProvider: userProvider,
                        userNoticeProvider: userNoticeProvider,
                        notices: _notices,
                      ),
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

class AddNoticeDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopNoticeProvider shopNoticeProvider;

  AddNoticeDialog({
    @required this.shop,
    @required this.shopNoticeProvider,
  });

  @override
  _AddNoticeDialogState createState() => _AddNoticeDialogState();
}

class _AddNoticeDialogState extends State<AddNoticeDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'お知らせ(通知)の新規登録',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopNoticeProvider.title,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: 'タイトル',
              iconData: Icons.title,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopNoticeProvider.message,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: '内容',
              iconData: Icons.short_text,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BorderBoxButton(
                  iconData: Icons.close,
                  labelText: '閉じる',
                  labelColor: Colors.blueGrey,
                  borderColor: Colors.blueGrey,
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: 4.0),
                FillBoxButton(
                  iconData: Icons.check,
                  labelText: '登録する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.shopNoticeProvider
                        .create(shopId: widget.shop?.id)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('お知らせ(通知)を登録しました')),
                    );
                    widget.shopNoticeProvider.clearController();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
