import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_product_regular.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_product_regular.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/screens/product_regular_table.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_form_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class ProductRegularScreen extends StatelessWidget {
  static const String id = 'product_regular';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopProductRegularProvider =
        Provider.of<ShopProductRegularProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final Stream<QuerySnapshot> streamProductRegular = FirebaseFirestore
        .instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('productRegular')
        .orderBy('deliveryAt', descending: false)
        .snapshots();
    List<ShopProductRegularModel> _productRegulars = [];

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamProductRegular,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _productRegulars.clear();
            for (DocumentSnapshot productRegular in snapshot.data.docs) {
              _productRegulars
                  .add(ShopProductRegularModel.fromSnapshot(productRegular));
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
                        Text('定期便', style: TextStyle(fontSize: 18.0)),
                        FillBoxButton(
                          iconData: Icons.add,
                          labelText: '新規登録',
                          labelColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddProductRegularDialog(
                                shop: shopProvider.shop,
                                shopProductRegularProvider:
                                    shopProductRegularProvider,
                                users: [],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text('登録した商品を「定期便」として登録できます。本日以前のデータは自動的に削除されます。'),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: ProductRegularTable(
                        shop: shopProvider.shop,
                        shopProductRegularProvider: shopProductRegularProvider,
                        productRegular: _productRegulars,
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

class AddProductRegularDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopProductRegularProvider shopProductRegularProvider;
  final List<UserModel> users;

  AddProductRegularDialog({
    @required this.shop,
    @required this.shopProductRegularProvider,
    @required this.users,
  });

  @override
  _AddProductRegularDialogState createState() =>
      _AddProductRegularDialogState();
}

class _AddProductRegularDialogState extends State<AddProductRegularDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '定期便の新規登録',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('お届け日', style: kLabelTextStyle),
            FillBoxFormButton(
              iconData: Icons.calendar_today,
              labelText:
                  '${DateFormat('yyyy/MM/dd').format(widget.shopProductRegularProvider.deliveryAt)}',
              labelColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: () async {
                var selected = await showDatePicker(
                  locale: const Locale('ja'),
                  context: context,
                  initialDate: widget.shopProductRegularProvider.deliveryAt,
                  firstDate: DateTime.now()
                      .add(Duration(days: widget.shop.cancelLimit)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (selected == null) return;
                setState(() {
                  widget.shopProductRegularProvider.deliveryAt = selected;
                });
              },
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
                    if (!await widget.shopProductRegularProvider
                        .create(shopId: widget.shop?.id, users: widget.users)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('定期便を登録しました')),
                    );
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
