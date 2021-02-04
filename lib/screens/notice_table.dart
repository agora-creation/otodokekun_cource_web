import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_notice.dart';
import 'package:otodokekun_cource_web/providers/shop_notice.dart';
import 'package:otodokekun_cource_web/services/shop_notice.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:responsive_table/DatatableHeader.dart';

class NoticeTable extends StatefulWidget {
  final ShopModel shop;
  final ShopNoticeProvider shopNoticeProvider;

  NoticeTable({@required this.shop, @required this.shopNoticeProvider});

  @override
  _NoticeTableState createState() => _NoticeTableState();
}

class _NoticeTableState extends State<NoticeTable> {
  final ShopNoticeService shopNoticeService = ShopNoticeService();
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: shopNoticeService.getNotices(shopId: widget.shop?.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          _isLoading = true;
        } else {
          _isLoading = false;
          _source.clear();
          for (DocumentSnapshot notice in snapshot.data.docs) {
            ShopNoticeModel _notice = ShopNoticeModel.fromSnapshot(notice);
            _source.add(_notice.toMap());
          }
        }
        return CustomTable(
          title: 'お知らせ一覧',
          actions: [
            FillBoxButton(
              labelText: '新規登録',
              labelColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return widget.shopNoticeProvider.isLoading
                        ? Center(child: LoadingWidget())
                        : CustomDialog(
                            title: '新規登録',
                            content: Container(
                              width: 400.0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    controller:
                                        widget.shopNoticeProvider.message,
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
                                  widget.shopNoticeProvider.changeLoading();
                                  if (!await widget.shopNoticeProvider
                                      .createNotice(shopId: widget.shop?.id)) {
                                    widget.shopNoticeProvider.changeLoading();
                                    return;
                                  }
                                  widget.shopNoticeProvider.clearController();
                                  widget.shopNoticeProvider.changeLoading();
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
            print('$value $item');
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
