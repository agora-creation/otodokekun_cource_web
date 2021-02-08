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
      show: true,
      sortable: true,
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
        widget.userProvider.blacklist = data['blacklist'];
        showDialog(
          context: context,
          builder: (_) {
            return UserCustomDialog(
              userProvider: widget.userProvider,
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

class UserCustomDialog extends StatefulWidget {
  final UserProvider userProvider;
  final dynamic data;
  final Function getSource;

  UserCustomDialog({
    @required this.userProvider,
    @required this.data,
    this.getSource,
  });

  @override
  _UserCustomDialogState createState() => _UserCustomDialogState();
}

class _UserCustomDialogState extends State<UserCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.data['name']}',
      content: Container(
        width: 400.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Table(
              border: TableBorder.all(width: 1.0, color: Colors.black54),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('住所'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('〒${widget.data['zip']}'),
                            Text('${widget.data['address']}'),
                            Text('${widget.data['tel']}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('メールアドレス'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('${widget.data['email']}'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('登録日時'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${DateFormat('yyyy/MM/dd HH:mm').format(widget.data['createdAt'])}',
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('ブラックリスト'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DropdownButton<bool>(
                          isExpanded: true,
                          value: widget.userProvider.blacklist,
                          onChanged: (value) {
                            setState(() {
                              widget.userProvider.blacklist = value;
                            });
                          },
                          items: widget.userProvider.blacklistList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text('$value'),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
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
          onTap: () async {
            if (!await widget.userProvider.updateUser(id: widget.data['id'])) {
              return;
            }
            widget.getSource();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
