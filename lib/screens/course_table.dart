import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class CourseTable extends StatefulWidget {
  final ShopProvider shopProvider;

  CourseTable({@required this.shopProvider});

  @override
  _CourseTableState createState() => _CourseTableState();
}

class _CourseTableState extends State<CourseTable> {
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
      text: 'コース(セット)名',
      value: 'title',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '開始日',
      value: 'openedAt',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '終了日',
      value: 'closedAt',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: 'DAYS',
      value: 'days',
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

  void _getSource() async {}

  @override
  void initState() {
    super.initState();
    _getSource();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      title: 'コース(セット)商品一覧',
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
