import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_product.dart';
import 'package:otodokekun_cource_web/services/shop_product.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class ProductTable extends StatefulWidget {
  final ShopModel shop;

  ProductTable({@required this.shop});

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  final ShopProductService shopProductService = ShopProductService();
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
      show: true,
      sortable: true,
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
      show: false,
      sortable: false,
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
    return StreamBuilder<QuerySnapshot>(
      stream: shopProductService.getProducts(shopId: widget.shop?.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          _isLoading = true;
        } else {
          _isLoading = false;
          _source.clear();
          for (DocumentSnapshot product in snapshot.data.docs) {
            ShopProductModel _product = ShopProductModel.fromSnapshot(product);
            _source.add(_product.toMap());
          }
        }
        return CustomTable(
          title: '商品一覧',
          actions: [
            FillBoxButton(
              labelText: '新規登録',
              labelColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              onTap: () {},
            ),
          ],
          headers: _headers,
          source: _source,
          selecteds: _selecteds,
          showSelect: true,
          onTabRow: (data) {},
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
