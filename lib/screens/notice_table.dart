import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/providers/shop_notice.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/providers/user_notice.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class NoticeTable extends StatefulWidget {
  final ShopModel shop;
  final ShopNoticeProvider shopNoticeProvider;
  final UserProvider userProvider;
  final UserNoticeProvider userNoticeProvider;
  final List<Map<String, dynamic>> source;

  NoticeTable({
    @required this.shop,
    @required this.shopNoticeProvider,
    @required this.userProvider,
    @required this.userNoticeProvider,
    @required this.source,
  });

  @override
  _NoticeTableState createState() => _NoticeTableState();
}

class _NoticeTableState extends State<NoticeTable> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
      text: 'タイトル',
      value: 'title',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '内容',
      value: 'message',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '登録日時',
      value: 'createdAtText',
      show: true,
      sortable: true,
    ),
  ];
  int _currentPerPage = 10;
  int _currentPage = 1;
  List<Map<String, dynamic>> _selecteds = [];
  String _sortColumn;
  bool _sortAscending = true;
  List<UserModel> _users = [];

  void _init() async {
    await widget.userProvider.selectList(shopId: widget.shop?.id).then((value) {
      _users = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      title: 'お知らせ一覧',
      actions: [
        FillBoxButton(
          iconData: Icons.add,
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () {
            widget.shopNoticeProvider.clearController();
            showDialog(
              context: context,
              builder: (_) {
                return AddNoticeDialog(
                  shop: widget.shop,
                  shopNoticeProvider: widget.shopNoticeProvider,
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
        widget.shopNoticeProvider.clearController();
        widget.shopNoticeProvider.title.text = data['title'];
        widget.shopNoticeProvider.message.text = data['message'];
        showDialog(
          context: context,
          builder: (_) {
            return EditNoticeDialog(
              shopNoticeProvider: widget.shopNoticeProvider,
              userNoticeProvider: widget.userNoticeProvider,
              data: data,
              users: _users,
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

class AddNoticeDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopNoticeProvider shopNoticeProvider;

  AddNoticeDialog({
    @required this.shop,
    @required this.shopNoticeProvider,
  });

  @override
  _AddNoticeDialogState createState() => _AddNoticeDialogState();
}

class _AddNoticeDialogState extends State<AddNoticeDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'お知らせの新規登録',
      content: Container(
        width: 450.0,
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
              iconData: Icons.message,
            ),
          ],
        ),
      ),
      actions: [
        BorderBoxButton(
          iconData: Icons.close,
          labelText: '閉じる',
          labelColor: Colors.blueGrey,
          borderColor: Colors.blueGrey,
          onTap: () => Navigator.pop(context),
        ),
        FillBoxButton(
          iconData: Icons.add,
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopNoticeProvider
                .create(shopId: widget.shop?.id)) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('登録が完了しました')),
            );
            widget.shopNoticeProvider.clearController();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class EditNoticeDialog extends StatefulWidget {
  final ShopNoticeProvider shopNoticeProvider;
  final UserNoticeProvider userNoticeProvider;
  final dynamic data;
  final List<UserModel> users;

  EditNoticeDialog({
    @required this.shopNoticeProvider,
    @required this.userNoticeProvider,
    @required this.data,
    @required this.users,
  });

  @override
  _EditNoticeDialogState createState() => _EditNoticeDialogState();
}

class _EditNoticeDialogState extends State<EditNoticeDialog> {
  final ScrollController _scrollController = ScrollController();
  List<UserModel> users = [];

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.data['title']}の詳細',
      content: Container(
        width: 450.0,
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
              iconData: Icons.message,
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
                  itemCount: widget.users.length,
                  itemBuilder: (context, index) {
                    UserModel _user = widget.users[index];
                    var contain = users.where((e) => e.id == _user.id);
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      child: CheckboxListTile(
                        title: Text('${_user.name}'),
                        value: contain.isNotEmpty,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          var contain = users.where((e) => e.id == _user.id);
                          setState(() {
                            if (contain.isEmpty) {
                              users.add(_user);
                            } else {
                              users.removeWhere((e) => e.id == _user.id);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(height: 0.0),
          ],
        ),
      ),
      actions: [
        BorderBoxButton(
          iconData: Icons.close,
          labelText: '閉じる',
          labelColor: Colors.blueGrey,
          borderColor: Colors.blueGrey,
          onTap: () => Navigator.pop(context),
        ),
        FillBoxButton(
          iconData: Icons.delete,
          labelText: '削除する',
          labelColor: Colors.white,
          backgroundColor: Colors.redAccent,
          onTap: () async {
            if (!await widget.shopNoticeProvider
                .delete(id: widget.data['id'], shopId: widget.data['shopId'])) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('削除が完了しました')),
            );
            widget.shopNoticeProvider.clearController();
            Navigator.pop(context);
          },
        ),
        FillBoxButton(
          iconData: Icons.check,
          labelText: '変更を保存',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopNoticeProvider
                .update(id: widget.data['id'], shopId: widget.data['shopId'])) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('変更が完了しました')),
            );
            widget.shopNoticeProvider.clearController();
            Navigator.pop(context);
          },
        ),
        BorderBoxButton(
          iconData: Icons.send,
          labelText: '送信する',
          labelColor: Colors.blueAccent,
          borderColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.userNoticeProvider.create(
                users: users,
                title: widget.shopNoticeProvider.title.text.trim(),
                message: widget.shopNoticeProvider.message.text)) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('送信が完了しました')),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
