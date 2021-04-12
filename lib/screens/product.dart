import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_product.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_product.dart';
import 'package:otodokekun_cource_web/screens/product_table.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopProductProvider = Provider.of<ShopProductProvider>(context);
    final Stream<QuerySnapshot> streamProduct = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('product')
        .orderBy('createdAt', descending: true)
        .snapshots();
    List<ShopProductModel> _products = [];

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamProduct,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _products.clear();
            for (DocumentSnapshot product in snapshot.data.docs) {
              _products.add(ShopProductModel.fromSnapshot(product));
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
                        Text('商品', style: TextStyle(fontSize: 18.0)),
                        FillBoxButton(
                          iconData: Icons.add,
                          labelText: '新規登録',
                          labelColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onTap: () {
                            shopProductProvider.clearController();
                            showDialog(
                              context: context,
                              builder: (_) => AddProductDialog(
                                shop: shopProvider.shop,
                                shopProductProvider: shopProductProvider,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text('店舗の商品を登録できます。商品は「個別注文」「定期注文」へ表示設定できます。'),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: ProductTable(
                        shopProductProvider: shopProductProvider,
                        products: _products,
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

class AddProductDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopProductProvider shopProductProvider;

  AddProductDialog({
    @required this.shop,
    @required this.shopProductProvider,
  });

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  Uint8List imageData;
  bool _published = true;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '商品の新規登録',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopProductProvider.name,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: '商品名',
              iconData: Icons.title,
            ),
            SizedBox(height: 8.0),
            Text('商品画像', style: kLabelTextStyle),
            GestureDetector(
              onTap: () {
                InputElement _input = FileUploadInputElement()
                  ..accept = 'image/*';
                _input.click();
                _input.onChange.listen((e) {
                  widget.shopProductProvider.imageFile = _input.files.first;
                  final reader = FileReader();
                  reader.readAsDataUrl(widget.shopProductProvider.imageFile);
                  reader.onLoadEnd.listen((e) {
                    final encoded = reader.result as String;
                    final stripped = encoded.replaceFirst(
                      RegExp(r'data:image/[^;]+;base64,'),
                      '',
                    );
                    setState(() {
                      imageData = base64.decode(stripped);
                    });
                  });
                });
              },
              child: imageData != null
                  ? Image.memory(
                      imageData,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/noimage.png',
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProductProvider.unit,
              obscureText: false,
              textInputType: null,
              maxLines: 1,
              labelText: '単位',
              iconData: Icons.category,
            ),
            Text(
              '例) 個、枚、台など',
              style: TextStyle(color: Colors.redAccent),
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProductProvider.price,
              obscureText: false,
              textInputType: TextInputType.number,
              maxLines: 1,
              labelText: '価格',
              iconData: Icons.money,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProductProvider.description,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: '商品説明',
              iconData: Icons.short_text,
            ),
            SizedBox(height: 8.0),
            CheckboxListTile(
              title: Text('「個別注文」へ表示する'),
              value: _published,
              activeColor: Colors.blueAccent,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  _published = value;
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
                    if (!await widget.shopProductProvider.create(
                        shopId: widget.shop?.id, published: _published)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('商品を登録しました')),
                    );
                    widget.shopProductProvider.clearController();
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
