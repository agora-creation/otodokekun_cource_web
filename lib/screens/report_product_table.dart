import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';

class ReportProductTable extends StatefulWidget {
  final List<ShopOrderModel> orders;

  ReportProductTable({@required this.orders});

  @override
  _ReportProductTableState createState() => _ReportProductTableState();
}

class _ReportProductTableState extends State<ReportProductTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NativeDataTable.builder(
      columns: [
        DataColumn(label: Text('商品名')),
        DataColumn(label: Text('価格')),
        DataColumn(label: Text('注文数量')),
        DataColumn(label: Text('注文金額')),
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
        return DataRow.byIndex(
          index: index,
          cells: [],
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
