import 'dart:html';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/cart.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_invoice.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/providers/shop_invoice.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/cart_list_tile.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class OrderTable extends StatefulWidget {
  final ShopModel shop;
  final ShopInvoiceProvider shopInvoiceProvider;
  final ShopOrderProvider shopOrderProvider;
  final ShopStaffProvider shopStaffProvider;
  final UserProvider userProvider;
  final List<Map<String, dynamic>> source;

  OrderTable({
    @required this.shop,
    @required this.shopInvoiceProvider,
    @required this.shopOrderProvider,
    @required this.shopStaffProvider,
    @required this.userProvider,
    @required this.source,
  });

  @override
  _OrderTableState createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
      text: '注文者',
      value: 'name',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '注文商品',
      value: 'cartText',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: 'お届け日',
      value: 'deliveryAtText',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '備考',
      value: 'remarks',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '合計金額',
      value: 'totalPrice',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '担当者',
      value: 'staff',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '配達状況',
      value: 'shippingText',
      show: true,
      sortable: true,
    ),
  ];
  int _currentPerPage = 10;
  int _currentPage = 1;
  List<Map<String, dynamic>> _selecteds = [];
  String _sortColumn;
  bool _sortAscending = true;
  List<ShopInvoiceModel> _invoices = [];
  List<ShopStaffModel> _staffs = [];
  List<UserModel> _users = [];

  void _init() async {
    await widget.shopInvoiceProvider
        .selectList(shopId: widget.shop?.id)
        .then((value) {
      _invoices = value;
    });
    await widget.shopStaffProvider
        .selectList(shopId: widget.shop?.id)
        .then((value) {
      _staffs = value;
    });
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
      title: '注文一覧',
      actions: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '注文者',
                  style: TextStyle(color: Colors.lightBlue, fontSize: 12.0),
                ),
                BorderBoxButton(
                  iconData: Icons.arrow_drop_down,
                  labelText: widget.shopOrderProvider.searchName != ''
                      ? '${widget.shopOrderProvider.searchName}'
                      : '選択なし',
                  labelColor: Colors.lightBlue,
                  borderColor: Colors.lightBlue,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return SearchNameDialog(
                          shopOrderProvider: widget.shopOrderProvider,
                          users: _users,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(width: 4.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'お届け日(締め日期間)',
                  style: TextStyle(color: Colors.lightBlue, fontSize: 12.0),
                ),
                BorderBoxButton(
                  iconData: Icons.calendar_today,
                  labelText:
                      '${DateFormat('yyyy/MM/dd').format(widget.shopOrderProvider.searchOpenedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(widget.shopOrderProvider.searchClosedAt)}',
                  labelColor: Colors.lightBlue,
                  borderColor: Colors.lightBlue,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return SearchInvoiceDialog(
                          shopOrderProvider: widget.shopOrderProvider,
                          invoices: _invoices,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(width: 4.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '担当者',
                  style: TextStyle(color: Colors.lightBlue, fontSize: 12.0),
                ),
                BorderBoxButton(
                  iconData: Icons.arrow_drop_down,
                  labelText: widget.shopOrderProvider.searchStaff != ''
                      ? '${widget.shopOrderProvider.searchStaff}'
                      : '選択なし',
                  labelColor: Colors.lightBlue,
                  borderColor: Colors.lightBlue,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return SearchStaffDialog(
                          shopOrderProvider: widget.shopOrderProvider,
                          staffs: _staffs,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(width: 4.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '配達状況',
                  style: TextStyle(color: Colors.lightBlue, fontSize: 12.0),
                ),
                BorderBoxButton(
                  iconData: Icons.arrow_drop_down,
                  labelText:
                      widget.shopOrderProvider.searchShipping ? '配達済み' : '配達待ち',
                  labelColor: Colors.lightBlue,
                  borderColor: Colors.lightBlue,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return SearchShippingDialog(
                          shopOrderProvider: widget.shopOrderProvider,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(width: 4.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '注文データ(CSV)',
                  style: TextStyle(color: Colors.green, fontSize: 12.0),
                ),
                BorderBoxButton(
                  iconData: Icons.file_download,
                  labelText: 'ダウンロード',
                  labelColor: Colors.green,
                  borderColor: Colors.green,
                  onTap: () {
                    List<List<dynamic>> rows = [];
                    for (int i = 0; i < widget.source.length; i++) {
                      List<dynamic> row = [];
                      row.add(widget.source[i]['name']);
                      row.add(widget.source[i]['zip']);
                      row.add(widget.source[i]['address']);
                      row.add(widget.source[i]['tel']);
                      row.add(widget.source[i]['cartText']);
                      row.add(widget.source[i]['deliveryAtText']);
                      row.add(widget.source[i]['remarks']);
                      row.add(widget.source[i]['totalPrice']);
                      row.add(widget.source[i]['staff']);
                      row.add(widget.source[i]['shippingText']);
                      rows.add(row);
                    }
                    String csv = const ListToCsvConverter().convert(rows);
                    AnchorElement(href: 'data:text/plain;charset=utf-8,$csv')
                      ..setAttribute('download', 'order.csv')
                      ..click();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
      headers: _headers,
      source: widget.source,
      selecteds: _selecteds,
      showSelect: false,
      onTabRow: (data) {
        widget.shopOrderProvider.staff = data['staff'];
        showDialog(
          context: context,
          builder: (_) {
            return EditOrderDialog(
              shopOrderProvider: widget.shopOrderProvider,
              data: data,
              staffs: _staffs,
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

class EditOrderDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final dynamic data;
  final List<ShopStaffModel> staffs;

  EditOrderDialog({
    @required this.shopOrderProvider,
    @required this.data,
    @required this.staffs,
  });

  @override
  _EditOrderDialogState createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  List<CartModel> cart = [];
  List<String> staffs = [];

  @override
  void initState() {
    super.initState();
    cart = widget.data['cart'];
    for (ShopStaffModel staff in widget.staffs) {
      staffs.add(staff.name);
    }
    staffs.insert(0, '');
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '注文の詳細',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('注文商品', style: kLabelTextStyle),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: cart.length,
              itemBuilder: (_, index) {
                CartModel _cart = cart[index];
                return CartListTile(
                  name: _cart.name,
                  image: _cart.image,
                  unit: _cart.unit,
                  price: _cart.price,
                  quantity: _cart.quantity,
                );
              },
            ),
            Text('注文日時', style: kLabelTextStyle),
            Text('${widget.data['createdAtText']}'),
            SizedBox(height: 8.0),
            Text('お届け日', style: kLabelTextStyle),
            Text('${widget.data['deliveryAtText']}'),
            SizedBox(height: 8.0),
            Text('注文者', style: kLabelTextStyle),
            Text('${widget.data['name']}'),
            SizedBox(height: 8.0),
            Text('お届け先', style: kLabelTextStyle),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('〒${widget.data['zip']}'),
                Text('${widget.data['address']}'),
                Text('${widget.data['tel']}'),
              ],
            ),
            SizedBox(height: 8.0),
            Text('備考', style: kLabelTextStyle),
            Text('${widget.data['remarks']}'),
            SizedBox(height: 8.0),
            Text('合計金額', style: kLabelTextStyle),
            Text('¥ ${widget.data['totalPrice']}'),
            SizedBox(height: 8.0),
            Text('担当者', style: kLabelTextStyle),
            DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              value: widget.shopOrderProvider.staff,
              onChanged: (value) {
                setState(() {
                  widget.shopOrderProvider.staff = value;
                });
              },
              items: staffs.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
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
        widget.data['shipping']
            ? null
            : BorderBoxButton(
                iconData: Icons.cancel_outlined,
                labelText: 'キャンセル',
                labelColor: Colors.redAccent,
                borderColor: Colors.redAccent,
                onTap: () async {
                  if (!await widget.shopOrderProvider.delete(
                      id: widget.data['id'], shopId: widget.data['shopId'])) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('キャンセルしました')),
                  );
                  Navigator.pop(context);
                },
              ),
        widget.data['shipping']
            ? null
            : FillBoxButton(
                iconData: Icons.check,
                labelText: '配達済みにする',
                labelColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                onTap: () async {
                  if (!await widget.shopOrderProvider.update(
                      id: widget.data['id'],
                      shopId: widget.data['shopId'],
                      userId: widget.data['userId'])) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('変更が完了しました')),
                  );
                  Navigator.pop(context);
                },
              ),
      ],
    );
  }
}

class SearchNameDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final List<UserModel> users;

  SearchNameDialog({
    @required this.shopOrderProvider,
    @required this.users,
  });

  @override
  _SearchNameDialogState createState() => _SearchNameDialogState();
}

class _SearchNameDialogState extends State<SearchNameDialog> {
  final ScrollController _scrollController = ScrollController();
  String _name = '';
  List<String> names = [];

  @override
  void initState() {
    super.initState();
    _name = widget.shopOrderProvider.searchName;
    for (UserModel user in widget.users) {
      names.add(user.name);
    }
    names.insert(0, '');
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '注文者で検索',
      content: Container(
        width: 350.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 300.0,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  controller: _scrollController,
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      child: RadioListTile(
                        title: Text(names[index] == '' ? '選択なし' : names[index]),
                        value: names[index],
                        groupValue: _name,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            _name = value;
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
          iconData: Icons.search,
          labelText: '検索する',
          labelColor: Colors.white,
          backgroundColor: Colors.lightBlue,
          onTap: () {
            widget.shopOrderProvider.changeSearchName(_name);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class SearchInvoiceDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final List<ShopInvoiceModel> invoices;

  SearchInvoiceDialog({
    @required this.shopOrderProvider,
    @required this.invoices,
  });

  @override
  _SearchInvoiceDialogState createState() => _SearchInvoiceDialogState();
}

class _SearchInvoiceDialogState extends State<SearchInvoiceDialog> {
  final ScrollController _scrollController = ScrollController();
  ShopInvoiceModel _selected;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'お届け日(締め日期間)で検索',
      content: Container(
        width: 350.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 300.0,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  controller: _scrollController,
                  itemCount: widget.invoices.length,
                  itemBuilder: (context, index) {
                    ShopInvoiceModel _invoice = widget.invoices[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      child: RadioListTile(
                        title: Text(
                            '${DateFormat('yyyy/MM/dd').format(_invoice.openedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(_invoice.closedAt)}'),
                        value: _invoice,
                        groupValue: _selected,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            _selected = value;
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
          iconData: Icons.search,
          labelText: '検索する',
          labelColor: Colors.white,
          backgroundColor: Colors.lightBlue,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class SearchStaffDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final List<ShopStaffModel> staffs;

  SearchStaffDialog({
    @required this.shopOrderProvider,
    @required this.staffs,
  });

  @override
  _SearchStaffDialogState createState() => _SearchStaffDialogState();
}

class _SearchStaffDialogState extends State<SearchStaffDialog> {
  final ScrollController _scrollController = ScrollController();
  String _staffName = '';
  List<String> staffs = [];

  @override
  void initState() {
    super.initState();
    _staffName = widget.shopOrderProvider.searchStaff;
    for (ShopStaffModel staff in widget.staffs) {
      staffs.add(staff.name);
    }
    staffs.insert(0, '');
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '担当者で検索',
      content: Container(
        width: 350.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 300.0,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  controller: _scrollController,
                  itemCount: staffs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      child: RadioListTile(
                        title:
                            Text(staffs[index] == '' ? '選択なし' : staffs[index]),
                        value: staffs[index],
                        groupValue: _staffName,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            _staffName = value;
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
          iconData: Icons.search,
          labelText: '検索する',
          labelColor: Colors.white,
          backgroundColor: Colors.lightBlue,
          onTap: () {
            widget.shopOrderProvider.changeSearchStaff(_staffName);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class SearchShippingDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;

  SearchShippingDialog({
    @required this.shopOrderProvider,
  });

  @override
  _SearchShippingDialogState createState() => _SearchShippingDialogState();
}

class _SearchShippingDialogState extends State<SearchShippingDialog> {
  bool _shipping = false;

  @override
  void initState() {
    super.initState();
    _shipping = widget.shopOrderProvider.searchShipping;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '担当者で検索',
      content: Container(
        width: 350.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 0.0),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: RadioListTile(
                title: Text('配達待ち'),
                value: false,
                groupValue: _shipping,
                activeColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    _shipping = value;
                  });
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: RadioListTile(
                title: Text('配達済み'),
                value: true,
                groupValue: _shipping,
                activeColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    _shipping = value;
                  });
                },
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
          iconData: Icons.search,
          labelText: '検索する',
          labelColor: Colors.white,
          backgroundColor: Colors.lightBlue,
          onTap: () {
            widget.shopOrderProvider.changeSearchShipping(_shipping);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
