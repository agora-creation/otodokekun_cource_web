import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';

class StaffTable extends StatefulWidget {
  final ShopModel shop;
  final ShopStaffProvider shopStaffProvider;
  final List<ShopStaffModel> staffs;

  StaffTable({
    @required this.shop,
    @required this.shopStaffProvider,
    @required this.staffs,
  });

  @override
  _StaffTableState createState() => _StaffTableState();
}

class _StaffTableState extends State<StaffTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NativeDataTable.builder(
      columns: [
        DataColumn(label: Text('登録日時')),
        DataColumn(label: Text('担当者名')),
        DataColumn(label: Text('詳細')),
      ],
      showSelect: false,
      rowsPerPage: _rowsPerPage,
      itemCount: widget.staffs?.length ?? 0,
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
        final ShopStaffModel staff = widget.staffs[index];
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(Text(
                '${DateFormat('yyyy/MM/dd HH:mm').format(staff.createdAt)}')),
            DataCell(Text('${staff.name}')),
            DataCell(
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.shopStaffProvider.clearController();
                      widget.shopStaffProvider.name.text = staff.name;
                      showDialog(
                        context: context,
                        builder: (_) => EditStaffDialog(
                          shopStaffProvider: widget.shopStaffProvider,
                          staff: staff,
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

class EditStaffDialog extends StatefulWidget {
  final ShopStaffProvider shopStaffProvider;
  final ShopStaffModel staff;

  EditStaffDialog({
    @required this.shopStaffProvider,
    @required this.staff,
  });

  @override
  _EditStaffDialogState createState() => _EditStaffDialogState();
}

class _EditStaffDialogState extends State<EditStaffDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '担当者の詳細',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopStaffProvider.name,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: '担当者名',
              iconData: Icons.supervisor_account_outlined,
            ),
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
                    if (!await widget.shopStaffProvider.delete(
                        id: widget.staff.id, shopId: widget.staff.shopId)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('担当者を削除しました')),
                    );
                    widget.shopStaffProvider.clearController();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 4.0),
                FillBoxButton(
                  iconData: Icons.check,
                  labelText: '保存する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.shopStaffProvider.update(
                        id: widget.staff.id, shopId: widget.staff.shopId)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('担当者を保存しました')),
                    );
                    widget.shopStaffProvider.clearController();
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
