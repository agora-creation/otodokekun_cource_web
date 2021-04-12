import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop_invoice.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_invoice.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/screens/order_table.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_form_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const String id = 'order';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopInvoiceProvider = Provider.of<ShopInvoiceProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final shopStaffProvider = Provider.of<ShopStaffProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    String _opened;
    String _closed;
    if (shopOrderProvider.deliveryAtDisabled) {
      if (shopOrderProvider.invoiceDisabled) {
        _opened =
            '${DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year - 1))} 00:00:00.000';
        _closed =
            '${DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year + 1))} 23:59:59.999';
      } else {
        _opened =
            '${DateFormat('yyyy-MM-dd').format(shopOrderProvider.openedAt)} 00:00:00.000';
        _closed =
            '${DateFormat('yyyy-MM-dd').format(shopOrderProvider.closedAt)} 23:59:59.999';
      }
    } else {
      _opened =
          '${DateFormat('yyyy-MM-dd').format(shopOrderProvider.deliveryAt)} 00:00:00.000';
      _closed =
          '${DateFormat('yyyy-MM-dd').format(shopOrderProvider.deliveryAt)} 23:59:59.999';
    }
    final _startAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(_closed).millisecondsSinceEpoch);
    final _endAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(_opened).millisecondsSinceEpoch);
    Stream<QuerySnapshot> _streamOrder;
    if (shopOrderProvider.userName != '' && shopOrderProvider.staff != '') {
      _streamOrder = FirebaseFirestore.instance
          .collection('shop')
          .doc(shopProvider.shop?.id)
          .collection('order')
          .where('shipping', isEqualTo: shopOrderProvider.shipping)
          .where('userName', isEqualTo: shopOrderProvider.userName)
          .where('staff', isEqualTo: shopOrderProvider.staff)
          .orderBy('deliveryAt', descending: true)
          .startAt([_startAt]).endAt([_endAt]).snapshots();
    } else if (shopOrderProvider.userName != '' &&
        shopOrderProvider.staff == '') {
      _streamOrder = FirebaseFirestore.instance
          .collection('shop')
          .doc(shopProvider.shop?.id)
          .collection('order')
          .where('shipping', isEqualTo: shopOrderProvider.shipping)
          .where('userName', isEqualTo: shopOrderProvider.userName)
          .orderBy('deliveryAt', descending: true)
          .startAt([_startAt]).endAt([_endAt]).snapshots();
    } else if (shopOrderProvider.userName == '' &&
        shopOrderProvider.staff != '') {
      _streamOrder = FirebaseFirestore.instance
          .collection('shop')
          .doc(shopProvider.shop?.id)
          .collection('order')
          .where('shipping', isEqualTo: shopOrderProvider.shipping)
          .where('staff', isEqualTo: shopOrderProvider.staff)
          .orderBy('deliveryAt', descending: true)
          .startAt([_startAt]).endAt([_endAt]).snapshots();
    } else {
      _streamOrder = FirebaseFirestore.instance
          .collection('shop')
          .doc(shopProvider.shop?.id)
          .collection('order')
          .where('shipping', isEqualTo: shopOrderProvider.shipping)
          .orderBy('deliveryAt', descending: true)
          .startAt([_startAt]).endAt([_endAt]).snapshots();
    }
    List<ShopOrderModel> _orders = [];
    List<ShopInvoiceModel> _invoices = [];
    List<UserModel> _users = [];
    List<ShopStaffModel> _staffs = [];

    Future<void> _future() async {
      await shopInvoiceProvider
          .selectList(shopId: shopProvider.shop?.id)
          .then((value) {
        _invoices = value;
      });
      await userProvider
          .selectList(shopId: shopProvider.shop?.id)
          .then((value) {
        _users = value;
      });
      await shopStaffProvider
          .selectList(shopId: shopProvider.shop?.id)
          .then((value) {
        _staffs = value;
      });
    }

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamOrder,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _orders.clear();
            for (DocumentSnapshot order in snapshot.data.docs) {
              _orders.add(ShopOrderModel.fromSnapshot(order));
            }
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: kSubColor),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: FutureBuilder(
                  future: _future(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {}
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('注文', style: TextStyle(fontSize: 18.0)),
                            Container(),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Text('顧客からの注文が表示されます。注文情報を確認の上、配達してください。'),
                        Divider(),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '締日(期間)で検索',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12.0,
                                  ),
                                ),
                                BorderBoxButton(
                                  iconData: Icons.date_range,
                                  labelText: '2021/01/01 〜 2021/12/31',
                                  labelColor: Colors.blueAccent,
                                  borderColor: Colors.blueAccent,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => SearchInvoicesDialog(
                                        shopOrderProvider: shopOrderProvider,
                                        invoices: _invoices,
                                      ),
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
                                  'お届け日で検索',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12.0,
                                  ),
                                ),
                                BorderBoxButton(
                                  iconData: Icons.today,
                                  labelText: '指定なし',
                                  labelColor: Colors.blueAccent,
                                  borderColor: Colors.blueAccent,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => SearchDeliveryAtDialog(
                                        shopOrderProvider: shopOrderProvider,
                                      ),
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
                                  '注文者で検索',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12.0,
                                  ),
                                ),
                                BorderBoxButton(
                                  iconData: Icons.person,
                                  labelText: '指定なし',
                                  labelColor: Colors.blueAccent,
                                  borderColor: Colors.blueAccent,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => SearchUserNameDialog(
                                        shopOrderProvider: shopOrderProvider,
                                        users: _users,
                                      ),
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
                                  '担当者で検索',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12.0,
                                  ),
                                ),
                                BorderBoxButton(
                                  iconData: Icons.supervisor_account_outlined,
                                  labelText: '指定なし',
                                  labelColor: Colors.blueAccent,
                                  borderColor: Colors.blueAccent,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => SearchStaffDialog(
                                        shopOrderProvider: shopOrderProvider,
                                        staffs: _staffs,
                                      ),
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
                                  '配達状況で検索',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12.0,
                                  ),
                                ),
                                BorderBoxButton(
                                  iconData: Icons.local_shipping,
                                  labelText: '未配達',
                                  labelColor: Colors.blueAccent,
                                  borderColor: Colors.blueAccent,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => SearchShippingDialog(
                                        shopOrderProvider: shopOrderProvider,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: OrderTable(
                            shop: shopProvider.shop,
                            shopOrderProvider: shopOrderProvider,
                            orders: _orders,
                            staffs: _staffs,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          } else {
            return LoadingWidget();
          }
        },
      ),
    );
  }
}

class SearchInvoicesDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final List<ShopInvoiceModel> invoices;

  SearchInvoicesDialog({
    @required this.shopOrderProvider,
    @required this.invoices,
  });

  @override
  _SearchInvoicesDialogState createState() => _SearchInvoicesDialogState();
}

class _SearchInvoicesDialogState extends State<SearchInvoicesDialog> {
  final ScrollController _scrollController = ScrollController();
  ShopInvoiceModel _selectedInvoice = ShopInvoiceModel.toNull();
  List<ShopInvoiceModel> _invoices = [];
  bool _disabled = false;

  @override
  void initState() {
    super.initState();
    for (ShopInvoiceModel _invoice in widget.invoices) {
      if (widget.shopOrderProvider.openedAt
              .isAtSameMomentAs(_invoice.openedAt) &&
          widget.shopOrderProvider.closedAt
              .isAtSameMomentAs(_invoice.closedAt)) {
        _selectedInvoice = _invoice;
      }
      _invoices.add(_invoice);
    }
    _invoices.insert(0, ShopInvoiceModel.toNull());
    _disabled = widget.shopOrderProvider.invoiceDisabled;
    if (widget.shopOrderProvider.invoiceDisabled) {
      _selectedInvoice = ShopInvoiceModel.toNull();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '締日(期間)で検索',
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
                  itemCount: _invoices.length,
                  itemBuilder: (context, index) {
                    ShopInvoiceModel _invoice = _invoices[index];
                    return Container(
                      decoration: kBottomBorderDecoration,
                      child: RadioListTile(
                        title: Text(_invoice.id == ''
                            ? '指定なし'
                            : '${DateFormat('yyyy/MM/dd').format(_invoice.openedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(_invoice.closedAt)}'),
                        value: _invoice,
                        groupValue: _selectedInvoice,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            _selectedInvoice = value;
                            if (_selectedInvoice.id == '') {
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
                  labelText: '検索する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    widget.shopOrderProvider.changeInvoice(
                        openedAt: _selectedInvoice.openedAt,
                        closedAt: _selectedInvoice.closedAt,
                        disabled: _disabled);
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
    _deliveryAt = widget.shopOrderProvider.deliveryAt;
    _disabled = widget.shopOrderProvider.deliveryAtDisabled;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'お届け日で検索',
      content: Container(
        width: 350.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FillBoxFormButton(
              iconData: Icons.today,
              labelText: '${DateFormat('yyyy/MM/dd').format(_deliveryAt)}',
              labelColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: () async {
                var _selected = await showDatePicker(
                  locale: const Locale('ja'),
                  context: context,
                  initialDate: _deliveryAt,
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (_selected == null) return;
                setState(() {
                  _deliveryAt = _selected;
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
                  labelText: '検索する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    widget.shopOrderProvider.changeDeliveryAt(
                        deliveryAt: _deliveryAt, disabled: _disabled);
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

class SearchUserNameDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final List<UserModel> users;

  SearchUserNameDialog({
    @required this.shopOrderProvider,
    @required this.users,
  });

  @override
  _SearchUserNameDialogState createState() => _SearchUserNameDialogState();
}

class _SearchUserNameDialogState extends State<SearchUserNameDialog> {
  final ScrollController _scrollController = ScrollController();
  String _userName = '';
  List<String> _userNames = [];

  @override
  void initState() {
    super.initState();
    _userName = widget.shopOrderProvider.userName;
    for (UserModel user in widget.users) {
      _userNames.add(user.name);
    }
    _userNames.insert(0, '');
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
                  itemCount: _userNames.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: kBottomBorderDecoration,
                      child: RadioListTile(
                        title: Text(_userNames[index] == ''
                            ? '指定なし'
                            : _userNames[index]),
                        value: _userNames[index],
                        groupValue: _userName,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            _userName = value;
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
                  iconData: Icons.search,
                  labelText: '検索する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    widget.shopOrderProvider
                        .changeUserName(userName: _userName);
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
  String _staff = '';
  List<String> _staffNames = [];

  @override
  void initState() {
    super.initState();
    _staff = widget.shopOrderProvider.staff;
    for (ShopStaffModel staff in widget.staffs) {
      _staffNames.add(staff.name);
    }
    _staffNames.insert(0, '');
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
                  itemCount: _staffNames.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: kBottomBorderDecoration,
                      child: RadioListTile(
                        title: Text(_staffNames[index] == ''
                            ? '指定なし'
                            : _staffNames[index]),
                        value: _staffNames[index],
                        groupValue: _staff,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            _staff = value;
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
                  iconData: Icons.search,
                  labelText: '検索する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    widget.shopOrderProvider.changeStaff(staff: _staff);
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

  SearchShippingDialog({@required this.shopOrderProvider});

  @override
  _SearchShippingDialogState createState() => _SearchShippingDialogState();
}

class _SearchShippingDialogState extends State<SearchShippingDialog> {
  bool _shipping = false;

  @override
  void initState() {
    super.initState();
    _shipping = widget.shopOrderProvider.shipping;
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
            Container(
              decoration: kBottomBorderDecoration,
              child: RadioListTile(
                title: Text('未配達'),
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
                  labelText: '検索する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    widget.shopOrderProvider
                        .changeShipping(shipping: _shipping);
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
