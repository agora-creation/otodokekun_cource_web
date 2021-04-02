import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:responsive_table/DatatableHeader.dart';
import 'package:responsive_table/responsive_table.dart';

class UserTable extends StatefulWidget {
  final ShopModel shop;
  final UserProvider userProvider;
  final List<Map<String, dynamic>> source;

  UserTable({
    @required this.shop,
    @required this.userProvider,
    @required this.source,
  });

  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
      text: '名前',
      value: 'name',
      show: true,
      sortable: true,
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
      value: 'blacklistText',
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
      title: '顧客一覧',
      actions: [],
      headers: _headers,
      source: widget.source,
      selecteds: _selecteds,
      showSelect: false,
      onTabRow: (data) {
        widget.userProvider.blacklist = data['blacklist'];
        showDialog(
          context: context,
          builder: (_) {
            return EditUserDialog(
              userProvider: widget.userProvider,
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

class EditUserDialog extends StatefulWidget {
  final UserProvider userProvider;
  final dynamic data;

  EditUserDialog({
    @required this.userProvider,
    @required this.data,
  });

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.data['name']}の詳細',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('名前', style: kLabelTextStyle),
            Text('${widget.data['name']}'),
            SizedBox(height: 8.0),
            Text('登録住所', style: kLabelTextStyle),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('〒${widget.data['zip']}'),
                Text('${widget.data['address']}'),
                Text('${widget.data['tel']}'),
              ],
            ),
            SizedBox(height: 8.0),
            Text('メールアドレス', style: kLabelTextStyle),
            Text('${widget.data['email']}'),
            SizedBox(height: 8.0),
            Text('ブラックリスト', style: kLabelTextStyle),
            DropdownButton<bool>(
              isExpanded: true,
              value: widget.userProvider.blacklist,
              onChanged: (value) {
                setState(() {
                  widget.userProvider.blacklist = value;
                });
              },
              items: [
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text('設定なし'),
                ),
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text('設定済み'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Divider(height: 0.0),
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
                  iconData: Icons.check,
                  labelText: '変更',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.userProvider
                        .update(id: widget.data['id'])) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('顧客情報を変更しました')),
                    );
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
