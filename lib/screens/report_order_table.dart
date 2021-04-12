import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';

class ReportOrderTable extends StatefulWidget {
  final List<ShopOrderModel> orders;

  ReportOrderTable({@required this.orders});

  @override
  _ReportOrderTableState createState() => _ReportOrderTableState();
}

class _ReportOrderTableState extends State<ReportOrderTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NativeDataTable.builder(
      columns: [
        DataColumn(label: Text('お届け日')),
        DataColumn(label: Text('注文者')),
        DataColumn(label: Text('注文商品')),
        DataColumn(label: Text('合計金額')),
        DataColumn(label: Text('備考')),
        DataColumn(label: Text('担当者')),
        DataColumn(label: Text('配達状況')),
      ],
      showSelect: false,
      rowsPerPage: _rowsPerPage,
      itemCount: widget.orders?.length ?? 0,
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
        final ShopOrderModel order = widget.orders[index];
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(
                Text('${DateFormat('yyyy/MM/dd').format(order.deliveryAt)}')),
            DataCell(Text('${order.userName}')),
            DataCell(order.cart.length > 1
                ? Text('${order.cart[0].name} 他')
                : Text('${order.cart[0].name}')),
            DataCell(Text('¥ ${order.totalPrice}')),
            DataCell(Text('${order.remarks}')),
            DataCell(Text('${order.staff}')),
            DataCell(order.shipping
                ? Text('配達完了')
                : Text(
                    '未配達',
                    style: TextStyle(color: Colors.redAccent),
                  )),
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
