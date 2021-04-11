import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/cart.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_invoice.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/providers/shop_invoice.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/cart_list_tile.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_form_button.dart';

class OrderTable extends StatefulWidget {
  final ShopModel shop;
  final ShopInvoiceProvider shopInvoiceProvider;
  final ShopOrderProvider shopOrderProvider;
  final ShopStaffProvider shopStaffProvider;
  final UserProvider userProvider;
  final List<ShopOrderModel> orders;

  OrderTable({
    @required this.shop,
    @required this.shopInvoiceProvider,
    @required this.shopOrderProvider,
    @required this.shopStaffProvider,
    @required this.userProvider,
    @required this.orders,
  });

  @override
  _OrderTableState createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
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
        DataColumn(label: Text('担当者')),
        DataColumn(label: Text('配達状況')),
        DataColumn(label: Text('詳細')),
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
            DataCell(Text('${order.cart[0].name} 他')),
            DataCell(Text('¥ ${order.totalPrice}')),
            DataCell(Text('${order.staff}')),
            DataCell(order.shipping
                ? Text('配達完了')
                : Text(
                    '未配達',
                    style: TextStyle(color: Colors.redAccent),
                  )),
            DataCell(
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () {},
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
  List<CartModel> products = [];
  List<String> staffs = [];

  @override
  void initState() {
    super.initState();
    products = widget.data['products'];
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
        width: 550.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('注文商品', style: kLabelTextStyle),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (_, index) {
                CartModel _products = products[index];
                return CartListTile(
                  name: _products.name,
                  image: _products.image,
                  unit: _products.unit,
                  price: _products.price,
                  quantity: _products.quantity,
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
            SizedBox(height: 16.0),
            Divider(height: 0.0),
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
                widget.data['shipping']
                    ? Container()
                    : BorderBoxButton(
                        iconData: Icons.cancel_outlined,
                        labelText: 'キャンセル',
                        labelColor: Colors.redAccent,
                        borderColor: Colors.redAccent,
                        onTap: () async {
                          if (!await widget.shopOrderProvider.delete(
                              id: widget.data['id'],
                              shopId: widget.data['shopId'])) {
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('注文情報をキャンセルしました')),
                          );
                          Navigator.pop(context);
                        },
                      ),
                SizedBox(width: 4.0),
                widget.data['shipping']
                    ? Container()
                    : FillBoxButton(
                        iconData: Icons.local_shipping,
                        labelText: '配達完了',
                        labelColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        onTap: () async {
                          if (!await widget.shopOrderProvider.updateShipping(
                              id: widget.data['id'],
                              shopId: widget.data['shopId'],
                              userId: widget.data['userId'])) {
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('配達状況を配達完了しました')),
                          );
                          Navigator.pop(context);
                        },
                      ),
                SizedBox(width: 4.0),
                FillBoxButton(
                  iconData: Icons.check,
                  labelText: '変更',
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
                      SnackBar(content: Text('注文情報を変更しました')),
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
                      decoration: kBottomBorderDecoration,
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
                  iconData: Icons.search,
                  labelText: '検索',
                  labelColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  onTap: () {
                    widget.shopOrderProvider.changeSearchName(_name);
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

class SearchDeliveryAtDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;

  SearchDeliveryAtDialog({@required this.shopOrderProvider});

  @override
  _SearchDeliveryAtDialogState createState() => _SearchDeliveryAtDialogState();
}

class _SearchDeliveryAtDialogState extends State<SearchDeliveryAtDialog> {
  DateTime _deliveryAt = DateTime.now();
  bool _disabled = true;

  @override
  void initState() {
    super.initState();
    _deliveryAt = widget.shopOrderProvider.searchDeliveryAt;
    _disabled = widget.shopOrderProvider.searchDeliveryAtDisabled;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'お届け日(日付検索)',
      content: Container(
        width: 350.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FillBoxFormButton(
              iconData: Icons.calendar_today,
              labelText: '${DateFormat('yyyy/MM/dd').format(_deliveryAt)}',
              labelColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: () async {
                var selected = await showDatePicker(
                  locale: const Locale('ja'),
                  context: context,
                  initialDate: _deliveryAt,
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (selected == null) return;
                setState(() {
                  _deliveryAt = selected;
                  _disabled = false;
                });
              },
            ),
            SizedBox(height: 4.0),
            CheckboxListTile(
              title: Text('指定なし'),
              value: _disabled,
              activeColor: Colors.blueAccent,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  _deliveryAt = DateTime.now();
                  _disabled = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Divider(height: 0.0),
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
                  iconData: Icons.search,
                  labelText: '検索',
                  labelColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  onTap: () {
                    widget.shopOrderProvider
                        .changeSearchDate(_deliveryAt, _disabled);
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
  ShopInvoiceModel _selected = ShopInvoiceModel.toNull();
  List<ShopInvoiceModel> invoices = [];
  bool _disabled = false;

  @override
  void initState() {
    super.initState();
    for (ShopInvoiceModel _invoice in widget.invoices) {
      if (widget.shopOrderProvider.searchOpenedAt
              .isAtSameMomentAs(_invoice.openedAt) &&
          widget.shopOrderProvider.searchClosedAt
              .isAtSameMomentAs(_invoice.closedAt)) {
        _selected = _invoice;
      }
      invoices.add(_invoice);
    }
    invoices.insert(0, ShopInvoiceModel.toNull());
    _disabled = widget.shopOrderProvider.searchOpenedClosedAtDisabled;
    if (widget.shopOrderProvider.searchOpenedClosedAtDisabled) {
      _selected = ShopInvoiceModel.toNull();
    }
  }

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
                  itemCount: invoices.length,
                  itemBuilder: (context, index) {
                    ShopInvoiceModel _invoice = invoices[index];
                    return Container(
                      decoration: kBottomBorderDecoration,
                      child: RadioListTile(
                        title: Text(_invoice.id == ''
                            ? '指定なし'
                            : '${DateFormat('yyyy/MM/dd').format(_invoice.openedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(_invoice.closedAt)}'),
                        value: _invoice,
                        groupValue: _selected,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            _selected = value;
                            if (_selected.id == '') {
                              _disabled = true;
                            } else {
                              _disabled = false;
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
                  iconData: Icons.search,
                  labelText: '検索',
                  labelColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  onTap: () {
                    widget.shopOrderProvider.changeSearchDateRage(
                        _selected.openedAt, _selected.closedAt, _disabled);
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
                      decoration: kBottomBorderDecoration,
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
                  iconData: Icons.search,
                  labelText: '検索',
                  labelColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  onTap: () {
                    widget.shopOrderProvider.changeSearchStaff(_staffName);
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
      title: '配達状況で検索',
      content: Container(
        width: 350.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 0.0),
            Container(
              decoration: kBottomBorderDecoration,
              child: RadioListTile(
                title: Text('配達予定'),
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
              decoration: kBottomBorderDecoration,
              child: RadioListTile(
                title: Text('配達完了'),
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
                  iconData: Icons.search,
                  labelText: '検索',
                  labelColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  onTap: () {
                    widget.shopOrderProvider.changeSearchShipping(_shipping);
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
