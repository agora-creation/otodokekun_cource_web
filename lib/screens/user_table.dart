import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:responsive_table/DatatableHeader.dart';
import 'package:responsive_table/responsive_table.dart';

class UserTable extends StatefulWidget {
  final ShopModel shop;
  final UserProvider userProvider;

  UserTable({@required this.shop, @required this.userProvider});

  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
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
      text: '名前',
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
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: 'メールアドレス',
      value: 'email',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: 'パスワード',
      value: 'password',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: 'ブラックリスト',
      value: 'blacklist',
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
    await widget.userProvider.getUsers(shopId: widget.shop?.id).then((value) {
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
      title: '顧客一覧',
      actions: [],
      headers: _headers,
      source: _source,
      selecteds: _selecteds,
      showSelect: false,
      onTabRow: (data) {
        showDialog(
          context: context,
          builder: (_) {
            return CustomDialog(
              title: '${data['name']}',
              content: Container(
                width: 400.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '住所',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Text('〒${data['zip']}'),
                    Text('${data['address']}'),
                    SizedBox(height: 8.0),
                    Text(
                      '電話番号',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Text('${data['tel']}'),
                    SizedBox(height: 8.0),
                    Text(
                      'メールアドレス',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Text('${data['email']}'),
                    SizedBox(height: 8.0),
                    Text(
                      '登録日時',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Text(
                      '${DateFormat('yyyy/MM/dd HH:mm').format(data['createdAt'])}',
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'ブラックリスト',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    DropdownButton<String>(
                      value: '無効',
                      onChanged: (value) {},
                      items: [
                        DropdownMenuItem<String>(
                          value: '無効',
                          child: Text('無効'),
                        ),
                        DropdownMenuItem<String>(
                          value: '有効',
                          child: Text('有効'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                FillRoundButton(
                  labelText: '変更を保存',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () {},
                ),
              ],
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
