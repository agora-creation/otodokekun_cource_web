import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop_product.dart';
import 'package:otodokekun_cource_web/providers/shop_product.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';

class ProductTable extends StatefulWidget {
  final ShopProductProvider shopProductProvider;
  final List<ShopProductModel> products;

  ProductTable({
    @required this.shopProductProvider,
    @required this.products,
  });

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NativeDataTable.builder(
      columns: [
        DataColumn(label: Text('商品名')),
        DataColumn(label: Text('価格')),
        DataColumn(label: Text('商品説明')),
        DataColumn(label: Text('個別注文')),
        DataColumn(label: Text('詳細')),
      ],
      showSelect: false,
      rowsPerPage: _rowsPerPage,
      itemCount: widget.products?.length ?? 0,
      firstRowIndex: _rowsOffset,
      handleNext: () {
        setState(() {
          _rowsOffset += _rowsPerPage;
        });
      },
      handlePrevious: () {
        setState(() {
          _rowsOffset -= _rowsPerPage;
        });
      },
      itemBuilder: (index) {
        final ShopProductModel product = widget.products[index];
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(Text('${product.name}')),
            DataCell(Text('¥ ${product.price}')),
            DataCell(Text('${product.description}')),
            DataCell(product.published
                ? Text(
                    '表示中',
                    style: TextStyle(color: Colors.redAccent),
                  )
                : Text('表示しない')),
            DataCell(
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.shopProductProvider.clearController();
                      widget.shopProductProvider.name.text = product.name;
                      widget.shopProductProvider.unit.text = product.unit;
                      widget.shopProductProvider.price.text =
                          product.price.toString();
                      widget.shopProductProvider.description.text =
                          product.description;
                      showDialog(
                        context: context,
                        builder: (_) => EditProductDialog(
                          shopProductProvider: widget.shopProductProvider,
                          product: product,
                        ),
                      );
                    },
                    icon: Icon(Icons.info_outline, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onRowsPerPageChanged: (value) {
        setState(() {
          _rowsPerPage = value;
        });
      },
    );
  }
}

class EditProductDialog extends StatefulWidget {
  final ShopProductProvider shopProductProvider;
  final ShopProductModel product;

  EditProductDialog({
    @required this.shopProductProvider,
    @required this.product,
  });

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  Uint8List imageData;
  bool _published = true;

  @override
  void initState() {
    super.initState();
    _published = widget.product.published;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '商品の詳細',
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
                  : widget.product.image != ''
                      ? Image.network(
                          widget.product.image,
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
                  iconData: Icons.delete,
                  labelText: '削除する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  onTap: () async {
                    if (!await widget.shopProductProvider.delete(
                        id: widget.product.id, shopId: widget.product.shopId)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('商品を削除しました')),
                    );
                    widget.shopProductProvider.clearController();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 4.0),
                FillBoxButton(
                  iconData: Icons.check,
                  labelText: '保存する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.shopProductProvider.update(
                        id: widget.product.id,
                        shopId: widget.product.shopId,
                        published: _published)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('商品を保存しました')),
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
