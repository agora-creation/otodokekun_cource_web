import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_notice.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/providers/shop_notice.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/providers/user_notice.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';

class NoticeTable extends StatefulWidget {
  final ShopModel shop;
  final ShopNoticeProvider shopNoticeProvider;
  final UserProvider userProvider;
  final UserNoticeProvider userNoticeProvider;
  final List<ShopNoticeModel> notices;

  NoticeTable({
    @required this.shop,
    @required this.shopNoticeProvider,
    @required this.userProvider,
    @required this.userNoticeProvider,
    @required this.notices,
  });

  @override
  _NoticeTableState createState() => _NoticeTableState();
}

class _NoticeTableState extends State<NoticeTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NativeDataTable.builder(
      columns: [
        DataColumn(label: Text('登録日時')),
        DataColumn(label: Text('タイトル')),
        DataColumn(label: Text('内容')),
        DataColumn(label: Text('詳細')),
      ],
      showSelect: false,
      rowsPerPage: _rowsPerPage,
      itemCount: widget.notices?.length ?? 0,
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
        final ShopNoticeModel notice = widget.notices[index];
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(Text(
                '${DateFormat('yyyy/MM/dd HH:mm').format(notice.createdAt)}')),
            DataCell(Text('${notice.title}')),
            DataCell(Text('${notice.message}')),
            DataCell(
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.shopNoticeProvider.clearController();
                      widget.shopNoticeProvider.title.text = notice.title;
                      widget.shopNoticeProvider.message.text = notice.message;
                      showDialog(
                        context: context,
                        builder: (_) => EditNoticeDialog(
                          shopNoticeProvider: widget.shopNoticeProvider,
                          userProvider: widget.userProvider,
                          userNoticeProvider: widget.userNoticeProvider,
                          notice: notice,
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

class EditNoticeDialog extends StatefulWidget {
  final ShopNoticeProvider shopNoticeProvider;
  final UserProvider userProvider;
  final UserNoticeProvider userNoticeProvider;
  final ShopNoticeModel notice;

  EditNoticeDialog({
    @required this.shopNoticeProvider,
    @required this.userProvider,
    @required this.userNoticeProvider,
    @required this.notice,
  });

  @override
  _EditNoticeDialogState createState() => _EditNoticeDialogState();
}

class _EditNoticeDialogState extends State<EditNoticeDialog> {
  final ScrollController _scrollController = ScrollController();
  List<UserModel> _users = [];
  List<UserModel> _selectedUsers = [];

  void _init() async {
    await widget.userProvider
        .selectListNotice(
            noticeId: widget.notice.id, shopId: widget.notice.shopId)
        .then((value) {
      setState(() => _users = value);
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'お知らせ(通知)の詳細',
      content: Container(
        width: 500.0,
        child: ListView(
          shrinkWrap: true,
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
              controller: widget.shopNoticeProvider.message,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: '内容',
              iconData: Icons.short_text,
            ),
            SizedBox(height: 16.0),
            Text('送信先選択', style: kLabelTextStyle),
            SizedBox(height: 8.0),
            Divider(height: 0.0),
            Container(
              height: 300.0,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  controller: _scrollController,
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    UserModel _user = _users[index];
                    var contain = _selectedUsers.where((e) => e.id == _user.id);
                    return Container(
                      decoration: kBottomBorderDecoration,
                      child: CheckboxListTile(
                        title: Text('${_user.name}'),
                        value: contain.isNotEmpty,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          var contain =
                              _selectedUsers.where((e) => e.id == _user.id);
                          setState(() {
                            if (contain.isEmpty) {
                              _selectedUsers.add(_user);
                            } else {
                              _selectedUsers
                                  .removeWhere((e) => e.id == _user.id);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
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
                    if (!await widget.shopNoticeProvider.delete(
                        id: widget.notice.id, shopId: widget.notice.shopId)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('お知らせ(通知)を削除しました')),
                    );
                    widget.shopNoticeProvider.clearController();
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
                    if (!await widget.shopNoticeProvider.update(
                        id: widget.notice.id, shopId: widget.notice.shopId)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('お知らせ(通知)を保存しました')),
                    );
                    widget.shopNoticeProvider.clearController();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 4.0),
                BorderBoxButton(
                  iconData: Icons.send,
                  labelText: '送信する',
                  labelColor: Colors.blueAccent,
                  borderColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.userNoticeProvider.create(
                        users: _selectedUsers,
                        id: widget.notice.id,
                        title: widget.shopNoticeProvider.title.text.trim(),
                        message: widget.shopNoticeProvider.message.text)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('お知らせ(通知)を指定の顧客に送信しました')),
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
