import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

class CustomTable extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final List<DatatableHeader> headers;
  final List<Map<String, dynamic>> source;
  final List<Map<String, dynamic>> selecteds;
  final dynamic Function(dynamic) onTabRow;
  final dynamic Function(dynamic) onSort;
  final bool sortAscending;
  final String sortColumn;
  final bool isLoading;
  final dynamic Function(bool, Map<String, dynamic>) onSelect;
  final dynamic Function(bool) onSelectAll;
  final dynamic Function(dynamic) currentPerPageOnChanged;
  final int currentPage;
  final int currentPerPage;
  final int total;
  final Function currentPageBack;
  final Function currentPageForward;
  static List<int> _perPages = [10, 20, 50, 100];

  CustomTable({
    this.title,
    this.actions,
    this.headers,
    this.source,
    this.selecteds,
    this.onTabRow,
    this.onSort,
    this.sortAscending,
    this.sortColumn,
    this.isLoading,
    this.onSelect,
    this.onSelectAll,
    this.currentPerPageOnChanged,
    this.currentPage,
    this.currentPerPage,
    this.total,
    this.currentPageBack,
    this.currentPageForward,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveDatatable(
      title: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      actions: actions,
      headers: headers,
      source: source,
      selecteds: selecteds,
      showSelect: false,
      autoHeight: false,
      onTabRow: onTabRow,
      onSort: onSort,
      sortAscending: sortAscending,
      sortColumn: sortColumn,
      isLoading: isLoading,
      onSelect: onSelect,
      onSelectAll: onSelectAll,
      footers: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('表示件数: '),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton(
            value: currentPerPage,
            items: _perPages
                .map((e) => DropdownMenuItem(
                      child: Text('$e'),
                      value: e,
                    ))
                .toList(),
            onChanged: currentPerPageOnChanged,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('$currentPage 〜 $currentPerPage 全 $total件'),
        ),
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: currentPageBack,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: currentPageForward,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ],
    );
  }
}
