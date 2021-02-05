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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.shopProductProvider.getProducts(shopId: widget.shop?.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.hasError) {
          _isLoading = true;
          _source.clear();
        }
        if (!snapshot.hasData) {
          _isLoading = false;
          _source.clear();
        } else {
          _isLoading = false;
          _source = snapshot.data;
        }
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
          source: _source,
          selecteds: _selecteds,
          showSelect: true,
          onTabRow: (data) {
            widget.shopProductProvider.clearController();
            widget.shopProductProvider.name.text = data['name'];
            showDialog(
              context: context,
              builder: (_) {
                return ProductCustomDialog(
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
                _source.sort(
                    (a, b) => b['$_sortColumn'].compareTo(a['$_sortColumn']));
              } else {
                _source.sort(
                    (a, b) => a['$_sortColumn'].compareTo(b['$_sortColumn']));
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
              setState(() =>
                  _selecteds = _source.map((entry) => entry).toList().cast());
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
              _currentPage =
                  _nextSet < _source.length ? _nextSet : _source.length;
            });
          },
        );
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
            CustomTextField(
              controller: null,
              obscureText: false,
              textInputType: null,
              maxLines: 1,
              labelText: '商品画像',
              iconData: Icons.image,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: null,
              obscureText: false,
              textInputType: null,
              maxLines: 1,
              labelText: '単位',
              iconData: Icons.ac_unit,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: null,
              obscureText: false,
              textInputType: TextInputType.number,
              maxLines: 1,
              labelText: '価格',
              iconData: Icons.attach_money,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: null,
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
                .createProduct(shopId: widget.shop?.id)) {
              return;
            }
            widget.shopProductProvider.clearController();
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

  ProductCustomDialog(
      {@required this.shopProductProvider, @required this.data});

  @override
  _ProductCustomDialogState createState() => _ProductCustomDialogState();
}

class _ProductCustomDialogState extends State<ProductCustomDialog> {
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
          ],
        ),
      ),
      actions: [
        FillRoundButton(
          labelText: '削除する',
          labelColor: Colors.white,
          backgroundColor: Colors.redAccent,
          onTap: () {},
        ),
        FillRoundButton(
          labelText: '変更を保存',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () {},
        ),
      ],
    );
  }
}
