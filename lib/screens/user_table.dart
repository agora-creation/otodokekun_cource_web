import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';

class UserTable extends StatefulWidget {
  final List<UserModel> users;

  UserTable({@required this.users});

  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NativeDataTable.builder(
      columns: [
        DataColumn(label: Text('登録日時')),
        DataColumn(label: Text('顧客名')),
        DataColumn(label: Text('電話番号')),
        DataColumn(label: Text('メールアドレス')),
        DataColumn(label: Text('定期便')),
        DataColumn(label: Text('詳細')),
      ],
      showSelect: false,
      rowsPerPage: _rowsPerPage,
      itemCount: widget.users?.length ?? 0,
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
        final UserModel user = widget.users[index];
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(Text(
                '${DateFormat('yyyy/MM/dd HH:mm').format(user.createdAt)}')),
            DataCell(Text('${user.name}')),
            DataCell(Text('${user.tel}')),
            DataCell(Text('${user.email}')),
            DataCell(user.regular
                ? Text(
                    '契約中',
                    style: TextStyle(color: Colors.redAccent),
                  )
                : Text('契約なし')),
            DataCell(
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditUserDialog(user: user),
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

class EditUserDialog extends StatefulWidget {
  final UserModel user;

  EditUserDialog({
    @required this.user,
  });

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '顧客の詳細',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('顧客名', style: kLabelTextStyle),
            Text('${widget.user.name}'),
            SizedBox(height: 8.0),
            Text('住所', style: kLabelTextStyle),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('〒${widget.user.zip}'),
                Text('${widget.user.address}'),
              ],
            ),
            SizedBox(height: 8.0),
            Text('電話番号', style: kLabelTextStyle),
            Text('${widget.user.tel}'),
            SizedBox(height: 8.0),
            Text('メールアドレス', style: kLabelTextStyle),
            Text('${widget.user.email}'),
            SizedBox(height: 8.0),
            Text('定期便', style: kLabelTextStyle),
            widget.user.regular
                ? Text(
                    '契約中',
                    style: TextStyle(color: Colors.redAccent),
                  )
                : Text('契約なし'),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
