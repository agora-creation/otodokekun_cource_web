import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_invoice.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_form_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class InvoiceTable extends StatefulWidget {
  final ShopModel shop;
  final ShopInvoiceProvider shopInvoiceProvider;
  final List<Map<String, dynamic>> source;

  InvoiceTable({
    @required this.shop,
    @required this.shopInvoiceProvider,
    @required this.source,
  });

  @override
  _InvoiceTableState createState() => _InvoiceTableState();
}

class _InvoiceTableState extends State<InvoiceTable> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
      text: '開始日',
      value: 'openedAtText',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '終了日',
      value: 'closedAtText',
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
      title: '締め日一覧',
      actions: [
        FillBoxButton(
          iconData: Icons.add,
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return AddInvoiceDialog(
                  shop: widget.shop,
                  shopInvoiceProvider: widget.shopInvoiceProvider,
                );
              },
            );
          },
        ),
      ],
      headers: _headers,
      source: widget.source,
      selecteds: _selecteds,
      showSelect: false,
      onTabRow: (data) {
        showDialog(
          context: context,
          builder: (_) {
            return EditInvoiceDialog(
              shopInvoiceProvider: widget.shopInvoiceProvider,
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

class AddInvoiceDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopInvoiceProvider shopInvoiceProvider;

  AddInvoiceDialog({
    @required this.shop,
    @required this.shopInvoiceProvider,
  });

  @override
  _AddInvoiceDialogState createState() => _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends State<AddInvoiceDialog> {
  DateTime openedAt = DateTime.now();
  DateTime closedAt = DateTime.now().add(Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '締め日の新規登録',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('締め日(期間)', style: kLabelTextStyle),
            SizedBox(height: 4.0),
            FillBoxFormButton(
              iconData: Icons.calendar_today,
              labelText:
                  '${DateFormat('yyyy/MM/dd').format(openedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(closedAt)}',
              labelColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: () async {
                final List<DateTime> selected =
                    await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: openedAt,
                  initialLastDate: closedAt,
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (selected != null && selected.length == 2) {
                  setState(() {
                    openedAt = selected.first;
                    closedAt = selected.last;
                  });
                }
              },
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
                  labelText: '登録',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.shopInvoiceProvider.create(
                        shopId: widget.shop?.id,
                        openedAt: openedAt,
                        closedAt: closedAt)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('登録が完了しました')),
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

class EditInvoiceDialog extends StatefulWidget {
  final ShopInvoiceProvider shopInvoiceProvider;
  final dynamic data;

  EditInvoiceDialog({
    @required this.shopInvoiceProvider,
    @required this.data,
  });

  @override
  _EditInvoiceDialogState createState() => _EditInvoiceDialogState();
}

class _EditInvoiceDialogState extends State<EditInvoiceDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '締め日の詳細',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('締め日(期間)', style: kLabelTextStyle),
            SizedBox(height: 4.0),
            FillBoxFormButton(
              iconData: Icons.calendar_today,
              labelText:
                  '${widget.data['openedAtText']} 〜 ${widget.data['closedAtText']}',
              labelColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: () {},
            ),
            SizedBox(height: 4.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '※変更はできません',
                style: TextStyle(fontSize: 14.0, color: Colors.redAccent),
              ),
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
                  iconData: Icons.delete,
                  labelText: '削除',
                  labelColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  onTap: () async {
                    if (!await widget.shopInvoiceProvider.delete(
                        id: widget.data['id'], shopId: widget.data['shopId'])) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('削除が完了しました')),
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
