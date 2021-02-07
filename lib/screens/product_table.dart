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

  ProductTable({@required this.shop, @required this.shopProductProvider});

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
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '登録日時',
      value: 'createdAt',
      show: false,
      sortable: false,
    ),
  ];
  int _currentPerPage = 10;
  int _currentPage = 1;
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;

  void _getSource() async {
    setState(() => _isLoading = true);
    await widget.shopProductProvider
        .getProducts(shopId: widget.shop?.id)
        .then((value) {
      _source = value;
      setState(() => _isLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _getSource();
  }

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
                  getSource: _getSource,
                );
              },
            );
          },
        ),
      ],
      headers: _headers,
      source: _source,
      selecteds: _selecteds,
      showSelect: true,
      onTabRow: (data) {
        widget.shopProductProvider.clearController();
        widget.shopProductProvider.name.text = data['name'];
        widget.shopProductProvider.unit.text = data['unit'];
        widget.shopProductProvider.price.text = data['price'].toString();
        widget.shopProductProvider.description.text = data['description'];
        showDialog(
          context: context,
          builder: (_) {
            return ProductCustomDialog(
              shopProductProvider: widget.shopProductProvider,
              data: data,
              getSource: _getSource,
            );
          },
        );
      },
      onSort: (value) {
        setState(() {
          _sortColumn = value;
          _sortAscending = !_sortAscending;
          if (_sortAscending) {
            _source
                .sort((a, b) => b['$_sortColumn'].compareTo(a['$_sortColumn']));
          } else {
            _source
                .sort((a, b) => a['$_sortColumn'].compareTo(b['$_sortColumn']));
          }
        });
      },
      sortAscending: _sortAscending,
      sortColumn: _sortColumn,
      isLoading: _isLoading,
      onSelect: (value, item) {
        if (value) {
          setState(() => _selecteds.add(item));
        } else {
          setState(() => _selecteds.removeAt(_selecteds.indexOf(item)));
        }
      },
      onSelectAll: (value) {
        if (value) {
          setState(
              () => _selecteds = _source.map((entry) => entry).toList().cast());
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
      total: _source.length,
      currentPageBack: () {
        var _nextSet = _currentPage - _currentPerPage;
        setState(() {
          _currentPage = _nextSet > 1 ? _nextSet : 1;
        });
      },
      currentPageForward: () {
        var _nextSet = _currentPage + _currentPerPage;
        setState(() {
          _currentPage = _nextSet < _source.length ? _nextSet : _source.length;
        });
      },
    );
  }
}

class AddProductCustomDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopProductProvider shopProductProvider;
  final Function getSource;

  AddProductCustomDialog({
    @required this.shop,
    @required this.shopProductProvider,
    this.getSource,
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
        width: 400.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                InputElement _imageInput = FileUploadInputElement()
                  ..accept = 'image/*';
                _imageInput.click();
                _imageInput.onChange.listen((event) {
                  final _imageFile = _imageInput.files.first;
                  final _reader = FileReader();
                  _reader.readAsDataUrl(_imageFile);
                  _reader.onLoadEnd.listen((event) {
                    final _encoded = _reader.result as String;
                    final _stripped = _encoded.replaceFirst(
                        RegExp(r'data:image/[^;]+;base64,'), '');
                    setState(() {
                      imageFile = _imageFile;
                      imageData = base64.decode(_stripped);
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
            widget.shopProductProvider.clearController();
            widget.getSource();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ProductCustomDialog extends StatefulWidget {
  final ShopProductProvider shopProductProvider;
  final dynamic data;
  final Function getSource;

  ProductCustomDialog({
    @required this.shopProductProvider,
    @required this.data,
    this.getSource,
  });

  @override
  _ProductCustomDialogState createState() => _ProductCustomDialogState();
}

class _ProductCustomDialogState extends State<ProductCustomDialog> {
  File imageFile;
  Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.data['name']}',
      content: Container(
        width: 400.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                InputElement _imageInput = FileUploadInputElement()
                  ..accept = 'image/*';
                _imageInput.click();
                _imageInput.onChange.listen((event) {
                  final _imageFile = _imageInput.files.first;
                  final _reader = FileReader();
                  _reader.readAsDataUrl(_imageFile);
                  _reader.onLoadEnd.listen((event) {
                    final _encoded = _reader.result as String;
                    final _stripped = _encoded.replaceFirst(
                        RegExp(r'data:image/[^;]+;base64,'), '');
                    setState(() {
                      imageFile = _imageFile;
                      imageData = base64.decode(_stripped);
                    });
                  });
                });
              },
              child: imageData != null
                  ? Image.memory(
                      imageData,
                      fit: BoxFit.cover,
                    )
                  : widget.data['image'] != null
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
                id: widget.data['id'], shopId: widget.data['shopId'])) {
              return;
            }
            widget.shopProductProvider.clearController();
            widget.getSource();
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
            widget.shopProductProvider.clearController();
            widget.getSource();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
