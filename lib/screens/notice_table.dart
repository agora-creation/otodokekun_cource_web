import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_notice.dart';
import 'package:otodokekun_cource_web/widgets/border_round_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class NoticeTable extends StatefulWidget {
  final ShopModel shop;
  final ShopNoticeProvider shopNoticeProvider;

  NoticeTable({@required this.shop, @required this.shopNoticeProvider});

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
    setState(() => _isLoading = true);
    await widget.shopNoticeProvider
        .getNotices(shopId: widget.shop?.id)
        .then((value) {
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
                return AddNoticeCustomDialog(
                  shop: widget.shop,
                  shopNoticeProvider: widget.shopNoticeProvider,
                  getSource: _getSource,
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
        widget.shopNoticeProvider.clearController();
        widget.shopNoticeProvider.title.text = data['title'];
        widget.shopNoticeProvider.message.text = data['message'];
        showDialog(
          context: context,
          builder: (_) {
            return NoticeCustomDialog(
              shopNoticeProvider: widget.shopNoticeProvider,
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

class AddNoticeCustomDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopNoticeProvider shopNoticeProvider;
  final Function getSource;

  AddNoticeCustomDialog({
    @required this.shop,
    @required this.shopNoticeProvider,
    this.getSource,
  });

  @override
  _AddNoticeCustomDialogState createState() => _AddNoticeCustomDialogState();
}

class _AddNoticeCustomDialogState extends State<AddNoticeCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '新規登録',
      content: Container(
        width: 400.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopNoticeProvider.title,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: 'タイトル',
              iconData: Icons.title,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopNoticeProvider.message,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
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
            if (!await widget.shopNoticeProvider
                .createNotice(shopId: widget.shop?.id)) {
              return;
            }
            widget.getSource();
            widget.shopNoticeProvider.clearController();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class NoticeCustomDialog extends StatefulWidget {
  final ShopNoticeProvider shopNoticeProvider;
  final dynamic data;
  final Function getSource;

  NoticeCustomDialog({
    @required this.shopNoticeProvider,
    @required this.data,
    this.getSource,
  });

  @override
  _NoticeCustomDialogState createState() => _NoticeCustomDialogState();
}

class _NoticeCustomDialogState extends State<NoticeCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.data['title']}',
      content: Container(
        width: 400.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopNoticeProvider.title,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: 'タイトル',
              iconData: Icons.title,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopNoticeProvider.message,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: '内容',
              iconData: Icons.message,
            ),
            SizedBox(height: 24.0),
            Text('顧客一覧'),
          ],
        ),
      ),
      actions: [
        BorderRoundButton(
          labelText: '送信する',
          labelColor: Colors.blueAccent,
          borderColor: Colors.blueAccent,
          onTap: () {},
        ),
        FillRoundButton(
          labelText: '削除する',
          labelColor: Colors.white,
          backgroundColor: Colors.redAccent,
          onTap: () async {
            if (!await widget.shopNoticeProvider.deleteNotice(
                id: widget.data['id'], shopId: widget.data['shopId'])) {
              return;
            }
            widget.getSource();
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
                id: widget.data['id'], shopId: widget.data['shopId'])) {
              return;
            }
            widget.getSource();
            widget.shopNoticeProvider.clearController();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
