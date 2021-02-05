import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:responsive_table/DatatableHeader.dart';

class OrderTable extends StatefulWidget {
  final ShopModel shop;
  final ShopOrderProvider shopOrderProvider;

  OrderTable({@required this.shop, @required this.shopOrderProvider});

  @override
  _OrderTableState createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
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
      text: '顧客ID',
      value: 'userId',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '顧客名',
      value: 'name',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '郵便番号',
      value: 'zip',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '住所',
      value: 'address',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '電話番号',
      value: 'tel',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: 'カート',
      value: 'cart',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: 'お届け予定日',
      value: 'deliveryAt',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '備考',
      value: 'remarks',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '合計金額',
      value: 'totalPrice',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '配達状況',
      value: 'shipping',
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
      future: widget.shopOrderProvider.getOrders(shopId: widget.shop?.id),
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
          title: '注文一覧',
          actions: [],
          headers: _headers,
          source: _source,
          selecteds: _selecteds,
          showSelect: false,
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
