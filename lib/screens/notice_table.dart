import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_notice.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class NoticeTable extends StatefulWidget {
  final ShopProvider shopProvider;
  final ShopNoticeProvider shopNoticeProvider;

  NoticeTable({@required this.shopProvider, @required this.shopNoticeProvider});

  @override
  _NoticeTableState createState() => _NoticeTableState();
}

class _NoticeTableState extends State<NoticeTable> {
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
      text: 'タイトル',
      value: 'title',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '内容',
      value: 'message',
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
      _source = await widget.shopNoticeProvider
          .getNoticesSource(shopId: widget.shopProvider.shop?.id);
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
      title: 'お知らせ一覧',
      actions: [
        FillBoxButton(
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () {
            widget.shopNoticeProvider.clearController();
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
                          controller: widget.shopNoticeProvider.title,
                          obscureText: false,
                          labelText: 'タイトル',
                          iconData: Icons.title,
                        ),
                        SizedBox(height: 8.0),
                        CustomTextField(
                          controller: widget.shopNoticeProvider.message,
                          obscureText: false,
                          labelText: '内容',
                          iconData: Icons.message,
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
                        if (!await widget.shopNoticeProvider.createNotice(
                            shopId: widget.shopProvider.shop.id)) {
                          return;
                        }
                        _getSource();
                        widget.shopNoticeProvider.clearController();
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
        widget.shopNoticeProvider.clearController();
        widget.shopNoticeProvider.title.text = data['title'];
        widget.shopNoticeProvider.message.text = data['message'];
        showDialog(
          context: context,
          builder: (_) {
            return CustomDialog(
              title: '${data['title']}',
              content: Container(
                width: 350.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: widget.shopNoticeProvider.title,
                      obscureText: false,
                      labelText: 'タイトル',
                      iconData: Icons.title,
                    ),
                    SizedBox(height: 8.0),
                    CustomTextField(
                      controller: widget.shopNoticeProvider.message,
                      obscureText: false,
                      labelText: '内容',
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
                  onTap: () async {
                    if (!await widget.shopNoticeProvider.deleteNotice(
                        id: data['id'], shopId: widget.shopProvider.shop.id)) {
                      return;
                    }
                    _getSource();
                    widget.shopNoticeProvider.clearController();
                    Navigator.pop(context);
                  },
                ),
                FillRoundButton(
                  labelText: '変更を保存',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.shopNoticeProvider.updateNotice(
                        id: data['id'], shopId: widget.shopProvider.shop.id)) {
                      return;
                    }
                    _getSource();
                    widget.shopNoticeProvider.clearController();
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
