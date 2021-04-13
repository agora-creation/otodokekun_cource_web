import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';

class ReportUserTable extends StatefulWidget {
  final List<ShopOrderModel> orders;

  ReportUserTable({@required this.orders});

  @override
  _ReportUserTableState createState() => _ReportUserTableState();
}

class _ReportUserTableState extends State<ReportUserTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NativeDataTable.builder(
      columns: [
        DataColumn(label: Text('顧客名')),
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
