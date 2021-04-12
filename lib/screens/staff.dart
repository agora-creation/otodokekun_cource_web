import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/screens/staff_table.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class StaffScreen extends StatelessWidget {
  static const String id = 'staff';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopStaffProvider = Provider.of<ShopStaffProvider>(context);
    final Stream<QuerySnapshot> streamStaff = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('staff')
        .orderBy('createdAt', descending: true)
        .snapshots();
    List<ShopStaffModel> _staffs = [];

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamStaff,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _staffs.clear();
            for (DocumentSnapshot staff in snapshot.data.docs) {
              _staffs.add(ShopStaffModel.fromSnapshot(staff));
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
                        Text('担当者', style: TextStyle(fontSize: 18.0)),
                        FillBoxButton(
                          iconData: Icons.add,
                          labelText: '新規登録',
                          labelColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onTap: () {
                            shopStaffProvider.clearController();
                            showDialog(
                              context: context,
                              builder: (_) => AddStaffDialog(
                                shop: shopProvider.shop,
                                shopStaffProvider: shopStaffProvider,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text('店舗スタッフを登録できます。各注文の担当者データとして使用します。'),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: StaffTable(
                        shopStaffProvider: shopStaffProvider,
                        staffs: _staffs,
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

class AddStaffDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopStaffProvider shopStaffProvider;

  AddStaffDialog({
    @required this.shop,
    @required this.shopStaffProvider,
  });

  @override
  _AddStaffDialogState createState() => _AddStaffDialogState();
}

class _AddStaffDialogState extends State<AddStaffDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '担当者の新規登録',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopStaffProvider.name,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: '担当者名',
              iconData: Icons.supervisor_account_outlined,
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
                    if (!await widget.shopStaffProvider
                        .create(shopId: widget.shop?.id)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('担当者を登録しました')),
                    );
                    widget.shopStaffProvider.clearController();
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
