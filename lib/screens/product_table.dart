import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_product.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class ProductTable extends StatefulWidget {
  final ShopModel shop;
  final ShopProductProvider shopProductProvider;
  final List<Map<String, dynamic>> source;

  ProductTable({
    @required this.shop,
    @required this.shopProductProvider,
    @required this.source,
  });

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
      text: 'ID',
      value: 'id',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '店舗ID',
      value: 'shopId',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '商品名',
      value: 'name',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '商品画像',
      value: 'image',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '単位',
      value: 'unit',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '価格',
      value: 'price',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '説明',
      value: 'description',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '公開設定',
      value: 'published',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '公開設定',
      value: 'publishedText',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '登録日時',
      value: 'createdAt',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '登録日時',
      value: 'createdAtText',
      show: true,
      sortable: true,
    ),
  ];
  int _currentPerPage = 10;
  int _currentPage = 1;
  List<Map<String, dynamic>> _selecteds = [];
  String _sortColumn;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      title: '商品一覧',
      actions: [
        FillBoxButton(
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () {
            widget.shopProductProvider.clearController();
            showDialog(
              context: context,
              builder: (_) {
                return AddProductCustomDialog(
                  shop: widget.shop,
                  shopProductProvider: widget.shopProductProvider,
                );
              },
            );
          },
        ),
      ],
      headers: _headers,
      source: widget.source,
      selecteds: _selecteds,
      showSelect: false,
      onTabRow: (data) {
        widget.shopProductProvider.clearController();
        widget.shopProductProvider.name.text = data['name'];
        widget.shopProductProvider.unit.text = data['unit'];
        widget.shopProductProvider.price.text = data['price'].toString();
        widget.shopProductProvider.description.text = data['description'];
        widget.shopProductProvider.published = data['published'];
        showDialog(
          context: context,
          builder: (_) {
            return EditProductCustomDialog(
              shopProductProvider: widget.shopProductProvider,
              data: data,
            );
          },
        );
      },
      onSort: (value) {
        setState(() {
          _sortColumn = value;
          _sortAscending = !_sortAscending;
          if (_sortAscending) {
            widget.source
                .sort((a, b) => b['$_sortColumn'].compareTo(a['$_sortColumn']));
          } else {
            widget.source
                .sort((a, b) => a['$_sortColumn'].compareTo(b['$_sortColumn']));
          }
        });
      },
      sortAscending: _sortAscending,
      sortColumn: _sortColumn,
      isLoading: false,
      onSelect: (value, item) {
        if (value) {
          setState(() => _selecteds.add(item));
        } else {
          setState(() => _selecteds.removeAt(_selecteds.indexOf(item)));
        }
      },
      onSelectAll: (value) {
        if (value) {
          setState(() =>
              _selecteds = widget.source.map((entry) => entry).toList().cast());
        } else {
          setState(() => _selecteds.clear());
        }
      },
      currentPerPageOnChanged: (value) {
        setState(() {
          _currentPerPage = value;
          //リセットデータ
        });
      },
      currentPage: _currentPage,
      currentPerPage: _currentPerPage,
      total: widget.source.length,
      currentPageBack: () {
        var _nextSet = _currentPage - _currentPerPage;
        setState(() {
          _currentPage = _nextSet > 1 ? _nextSet : 1;
        });
      },
      currentPageForward: () {
        var _nextSet = _currentPage + _currentPerPage;
        setState(() {
          _currentPage =
              _nextSet < widget.source.length ? _nextSet : widget.source.length;
        });
      },
    );
  }
}

class AddProductCustomDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopProductProvider shopProductProvider;

  AddProductCustomDialog({
    @required this.shop,
    @required this.shopProductProvider,
  });

  @override
  _AddProductCustomDialogState createState() => _AddProductCustomDialogState();
}

class _AddProductCustomDialogState extends State<AddProductCustomDialog> {
  File imageFile;
  Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '新規登録',
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
            Row(
              children: [
                Icon(Icons.image),
                Text('商品画像'),
              ],
            ),
            GestureDetector(
              onTap: () {
                InputElement _input = FileUploadInputElement()
                  ..accept = 'image/*';
                _input.click();
                _input.onChange.listen((e) {
                  imageFile = _input.files.first;
                  final reader = FileReader();
                  reader.readAsDataUrl(imageFile);
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
              iconData: Icons.ac_unit,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProductProvider.price,
              obscureText: false,
              textInputType: TextInputType.number,
              maxLines: 1,
              labelText: '価格',
              iconData: Icons.attach_money,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProductProvider.description,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: '説明',
              iconData: Icons.description,
            ),
          ],
        ),
      ),
      actions: [
        FillRoundButton(
          labelText: '登録する',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopProductProvider
                .createProduct(shopId: widget.shop?.id, imageFile: imageFile)) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('登録が完了しました')),
            );
            widget.shopProductProvider.clearController();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class EditProductCustomDialog extends StatefulWidget {
  final ShopProductProvider shopProductProvider;
  final dynamic data;

  EditProductCustomDialog({
    @required this.shopProductProvider,
    @required this.data,
  });

  @override
  _EditProductCustomDialogState createState() =>
      _EditProductCustomDialogState();
}

class _EditProductCustomDialogState extends State<EditProductCustomDialog> {
  File imageFile;
  Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.data['name']}',
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
            Row(
              children: [
                Icon(Icons.image),
                Text('商品画像'),
              ],
            ),
            GestureDetector(
              onTap: () {
                InputElement _input = FileUploadInputElement()
                  ..accept = 'image/*';
                _input.click();
                _input.onChange.listen((e) {
                  imageFile = _input.files.first;
                  final reader = FileReader();
                  reader.readAsDataUrl(imageFile);
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
                  : widget.data['image'] != ''
                      ? Image.network(
                          widget.data['image'],
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
              iconData: Icons.ac_unit,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProductProvider.price,
              obscureText: false,
              textInputType: TextInputType.number,
              maxLines: 1,
              labelText: '価格',
              iconData: Icons.attach_money,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopProductProvider.description,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: '説明',
              iconData: Icons.description,
            ),
            SizedBox(height: 8.0),
            DropdownButton<bool>(
              isExpanded: true,
              value: widget.shopProductProvider.published,
              onChanged: (value) {
                setState(() {
                  widget.shopProductProvider.published = value;
                });
              },
              items: [
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text('非公開'),
                ),
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text('公開'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        FillRoundButton(
          labelText: '削除する',
          labelColor: Colors.white,
          backgroundColor: Colors.redAccent,
          onTap: () async {
            if (!await widget.shopProductProvider.deleteProduct(
                id: widget.data['id'],
                shopId: widget.data['shopId'],
                image: widget.data['image'])) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('削除が完了しました')),
            );
            widget.shopProductProvider.clearController();
            Navigator.pop(context);
          },
        ),
        FillRoundButton(
          labelText: '変更を保存',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopProductProvider.updateProduct(
                id: widget.data['id'],
                shopId: widget.data['shopId'],
                imageFile: imageFile)) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('変更が完了しました')),
            );
            widget.shopProductProvider.clearController();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
