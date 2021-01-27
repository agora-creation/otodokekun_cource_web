import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

class CustomTable extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final List<DatatableHeader> headers;
  final List<Map<String, dynamic>> source;
  final List<Map<String, dynamic>> selecteds;
  final dynamic Function(dynamic) onSort;
  final bool sortAscending;
  final String sortColumn;
  final bool isLoading;
  final dynamic Function(bool, Map<String, dynamic>) onSelect;
  final dynamic Function(bool) onSelectAll;

  CustomTable({
    this.title,
    this.actions,
    this.headers,
    this.source,
    this.selecteds,
    this.onSort,
    this.sortAscending,
    this.sortColumn,
    this.isLoading,
    this.onSelect,
    this.onSelectAll,
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
      showSelect: true,
      autoHeight: false,
      onTabRow: (data) {
        print(data);
      },
      onSort: onSort,
      sortAscending: sortAscending,
      sortColumn: sortColumn,
      isLoading: isLoading,
      onSelect: onSelect,
      onSelectAll: onSelectAll,
      footers: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('表示件数'),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton(
            value: 10,
            items: [
              DropdownMenuItem(child: Text('10'), value: 10),
            ],
            onChanged: (value) {},
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('1 〜 10 全10件'),
        ),
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {},
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ],
    );
  }
}
