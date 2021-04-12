import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop_invoice.dart';
import 'package:otodokekun_cource_web/providers/shop_invoice.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_form_button.dart';

class InvoiceTable extends StatefulWidget {
  final ShopInvoiceProvider shopInvoiceProvider;
  final List<ShopInvoiceModel> invoices;

  InvoiceTable({
    @required this.shopInvoiceProvider,
    @required this.invoices,
  });

  @override
  _InvoiceTableState createState() => _InvoiceTableState();
}

class _InvoiceTableState extends State<InvoiceTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NativeDataTable.builder(
      columns: [
        DataColumn(label: Text('開始日')),
        DataColumn(label: Text('終了日')),
        DataColumn(label: Text('詳細')),
      ],
      showSelect: false,
      rowsPerPage: _rowsPerPage,
      itemCount: widget.invoices?.length ?? 0,
      firstRowIndex: _rowsOffset,
      handleNext: () {
        setState(() {
          _rowsOffset += _rowsPerPage;
        });
      },
      handlePrevious: () {
        setState(() {
          _rowsOffset -= _rowsPerPage;
        });
      },
      itemBuilder: (index) {
        final ShopInvoiceModel invoice = widget.invoices[index];
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(
                Text('${DateFormat('yyyy/MM/dd').format(invoice.openedAt)}')),
            DataCell(
                Text('${DateFormat('yyyy/MM/dd').format(invoice.closedAt)}')),
            DataCell(
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditInvoiceDialog(
                          shopInvoiceProvider: widget.shopInvoiceProvider,
                          invoice: invoice,
                        ),
                      );
                    },
                    icon: Icon(Icons.info_outline, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onRowsPerPageChanged: (value) {
        setState(() {
          _rowsPerPage = value;
        });
      },
    );
  }
}

class EditInvoiceDialog extends StatefulWidget {
  final ShopInvoiceProvider shopInvoiceProvider;
  final ShopInvoiceModel invoice;

  EditInvoiceDialog({
    @required this.shopInvoiceProvider,
    @required this.invoice,
  });

  @override
  _EditInvoiceDialogState createState() => _EditInvoiceDialogState();
}

class _EditInvoiceDialogState extends State<EditInvoiceDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '締日(期間)の詳細',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('締日(期間)', style: kLabelTextStyle),
            SizedBox(height: 4.0),
            FillBoxFormButton(
              iconData: Icons.calendar_today,
              labelText:
                  '${DateFormat('yyyy/MM/dd').format(widget.invoice.openedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(widget.invoice.closedAt)}',
              labelColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: () {},
            ),
            Text(
              '※変更はできません',
              style: TextStyle(color: Colors.redAccent),
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
                  labelText: '削除する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  onTap: () async {
                    if (!await widget.shopInvoiceProvider.delete(
                        id: widget.invoice.id, shopId: widget.invoice.shopId)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('締日(期間)を削除しました')),
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
