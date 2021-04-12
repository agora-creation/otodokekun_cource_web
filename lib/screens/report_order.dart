import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/screens/report_order_table.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class ReportOrderScreen extends StatelessWidget {
  static const String id = 'report_order';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
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
        .orderBy('deliveryAt', descending: true)
        .startAt([_startAt]).endAt([_endAt]).snapshots();
    List<ShopOrderModel> _orders = [];

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('集計 - 注文毎', style: TextStyle(fontSize: 18.0)),
                        FillBoxButton(
                          iconData: Icons.file_download,
                          labelText: 'CSVダウンロード',
                          labelColor: Colors.white,
                          backgroundColor: Colors.teal,
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text('注文毎の集計を見ることができます。締日(期間)で検索し、表示してください。'),
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
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: ReportOrderTable(orders: _orders),
                    ),
                  ],
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
