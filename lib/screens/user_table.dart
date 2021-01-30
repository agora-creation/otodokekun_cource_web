import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:responsive_table/DatatableHeader.dart';
import 'package:responsive_table/responsive_table.dart';

class UserTable extends StatefulWidget {
  final ShopProvider shopProvider;
  final UserProvider userProvider;

  UserTable({@required this.shopProvider, @required this.userProvider});

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
      _source = await widget.userProvider
          .getUsersSource(shopId: widget.shopProvider.shop?.id);
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
      actions: [
        FillBoxButton(
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () {
            widget.userProvider.clearController();
            showDialog(
              context: context,
              builder: (_) {
                return CustomDialog(
                  title: '新規登録',
                  content: Container(
                    width: 350.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: widget.userProvider.name,
                          obscureText: false,
                          labelText: '名前',
                          iconData: Icons.person,
                        ),
                        SizedBox(height: 8.0),
                        CustomTextField(
                          controller: widget.userProvider.zip,
                          obscureText: false,
                          labelText: '郵便番号',
                          iconData: Icons.location_pin,
                        ),
                        SizedBox(height: 8.0),
                        CustomTextField(
                          controller: widget.userProvider.address,
                          obscureText: false,
                          labelText: '住所',
                          iconData: Icons.business,
                        ),
                        SizedBox(height: 8.0),
                        CustomTextField(
                          controller: widget.userProvider.tel,
                          obscureText: false,
                          labelText: '電話番号',
                          iconData: Icons.phone,
                        ),
                        SizedBox(height: 8.0),
                        CustomTextField(
                          controller: widget.userProvider.email,
                          obscureText: false,
                          labelText: 'メールアドレス',
                          iconData: Icons.email,
                        ),
                        SizedBox(height: 8.0),
                        CustomTextField(
                          controller: widget.userProvider.password,
                          obscureText: true,
                          labelText: 'パスワード',
                          iconData: Icons.lock,
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
                        if (!await widget.userProvider
                            .createUser(shop: widget.shopProvider.shop)) {
                          return;
                        }
                        _getSource();
                        widget.userProvider.clearController();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
      headers: _headers,
      source: _source,
      selecteds: _selecteds,
      onTabRow: (data) {
        widget.userProvider.clearController();
        widget.userProvider.name.text = data['name'];
        widget.userProvider.zip.text = data['zip'];
        widget.userProvider.address.text = data['address'];
        widget.userProvider.tel.text = data['tel'];
        showDialog(
          context: context,
          builder: (_) {
            return CustomDialog(
              title: '${data['name']}',
              content: Container(
                width: 350.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: widget.userProvider.name,
                      obscureText: false,
                      labelText: '名前',
                      iconData: Icons.person,
                    ),
                    SizedBox(height: 8.0),
                    CustomTextField(
                      controller: widget.userProvider.zip,
                      obscureText: false,
                      labelText: '郵便番号',
                      iconData: Icons.location_pin,
                    ),
                    SizedBox(height: 8.0),
                    CustomTextField(
                      controller: widget.userProvider.address,
                      obscureText: false,
                      labelText: '住所',
                      iconData: Icons.business,
                    ),
                    SizedBox(height: 8.0),
                    CustomTextField(
                      controller: widget.userProvider.tel,
                      obscureText: false,
                      labelText: '電話番号',
                      iconData: Icons.phone,
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
                    if (!await widget.userProvider.deleteUser(
                        id: data['id'],
                        shop: widget.shopProvider.shop,
                        email: data['email'],
                        password: data['password'])) {
                      return;
                    }
                    _getSource();
                    widget.userProvider.clearController();
                    Navigator.pop(context);
                  },
                ),
                FillRoundButton(
                  labelText: '変更を保存',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.userProvider.updateUser(
                        id: data['id'], shop: widget.shopProvider.shop)) {
                      return;
                    }
                    _getSource();
                    widget.userProvider.clearController();
                    Navigator.pop(context);
                  },
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
