import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop_invoice.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_invoice.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/screens/report_user_table.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class ReportUserScreen extends StatelessWidget {
  static const String id = 'report_user';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopInvoiceProvider = Provider.of<ShopInvoiceProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    String _opened;
    String _closed;
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
    final _startAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(_closed).millisecondsSinceEpoch);
    final _endAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(_opened).millisecondsSinceEpoch);
    Stream<QuerySnapshot> _streamOrder = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('order')
        .where('shipping', isEqualTo: true)
        .orderBy('deliveryAt', descending: true)
        .startAt([_startAt]).endAt([_endAt]).snapshots();
    List<ShopOrderModel> _orders = [];
    List<ShopInvoiceModel> _invoices = [];
    List<UserModel> _users = [];

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
                    for (UserModel _user in _users) {
                      for (ShopOrderModel _order in _orders) {
                        if (_user.id == _order.userId) {
                          _user.orderQuantity = _order.cart[0].quantity;
                          _user.orderPrice = _order.cart[0].totalPrice;
                        }
                      }
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('集計 - 顧客毎', style: TextStyle(fontSize: 18.0)),
                            FillBoxButton(
                              iconData: Icons.file_download,
                              labelText: 'CSVダウンロード',
                              labelColor: Colors.white,
                              backgroundColor: Colors.teal,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => CSVDownloadDialog(
                                    users: _users,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Text('顧客毎の集計を見ることができます。締日(期間)で検索し、表示してください。'),
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
                                  labelText: shopOrderProvider.invoiceDisabled
                                      ? '指定なし'
                                      : '${DateFormat('yyyy/MM/dd').format(shopOrderProvider.openedAt)}} 〜 ${DateFormat('yyyy/MM/dd').format(shopOrderProvider.closedAt)}',
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
                                  '顧客名で検索',
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
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: ReportUserTable(users: _users),
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

class CSVDownloadDialog extends StatelessWidget {
  final List<UserModel> users;

  CSVDownloadDialog({@required this.users});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'CSVダウンロード',
      content: Container(
        width: 350.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '※ダウンロードしたCSVファイルをエクセルで開く際、文字化けする可能性があります。文字コードをUTF-8からSJISに変更すると解消します。他社システムにインポートする際は問題ありません。',
              style: TextStyle(color: Colors.redAccent),
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
                  iconData: Icons.file_download,
                  labelText: 'ダウンロードする',
                  labelColor: Colors.white,
                  backgroundColor: Colors.teal,
                  onTap: () {
                    List<List<dynamic>> _rows = [];
                    for (int i = 0; i < users.length; i++) {
                      List<dynamic> _row = [];
                      _row.add('${users[i].name}');
                      _row.add('${users[i].orderQuantity}');
                      _row.add('${users[i].orderPrice}');
                      _rows.add(_row);
                    }
                    String _csv = const ListToCsvConverter().convert(_rows);
                    AnchorElement(href: 'data:text/plain;charset=utf-8,$_csv')
                      ..setAttribute('download', 'report_user.csv')
                      ..click();
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
