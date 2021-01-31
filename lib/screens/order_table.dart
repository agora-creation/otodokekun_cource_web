import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:responsive_table/DatatableHeader.dart';

class OrderTable extends StatefulWidget {
  final ShopProvider shopProvider;
  final ShopOrderProvider shopOrderProvider;

  OrderTable({@required this.shopProvider, @required this.shopOrderProvider});

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
      value: 'title',
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
      text: '登録日時',
      value: 'createdAt',
      show: true,
      sortable: true,
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
    _source.clear();
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 3)).then((value) async {
      _source = await widget.shopOrderProvider
          .getOrdersSource(shopId: widget.shopProvider.shop?.id);
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
      title: '注文一覧',
      actions: [],
      headers: _headers,
      source: _source,
      selecteds: _selecteds,
      onTabRow: (data) {},
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
