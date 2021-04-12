import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_invoice.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_invoice.dart';
import 'package:otodokekun_cource_web/screens/invoice_table.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_form_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class InvoiceScreen extends StatelessWidget {
  static const String id = 'invoice';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopInvoiceProvider = Provider.of<ShopInvoiceProvider>(context);
    final Stream<QuerySnapshot> streamInvoice = FirebaseFirestore.instance
        .collection('shop')
        .doc(shopProvider.shop?.id)
        .collection('invoice')
        .orderBy('openedAt', descending: true)
        .snapshots();
    List<ShopInvoiceModel> _invoices = [];

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamInvoice,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _invoices.clear();
            for (DocumentSnapshot invoice in snapshot.data.docs) {
              _invoices.add(ShopInvoiceModel.fromSnapshot(invoice));
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
                        Text('締日(期間)', style: TextStyle(fontSize: 18.0)),
                        FillBoxButton(
                          iconData: Icons.add,
                          labelText: '新規登録',
                          labelColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddInvoiceDialog(
                                shop: shopProvider.shop,
                                shopInvoiceProvider: shopInvoiceProvider,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text('店舗の締日を期間ごとに登録できます。この期間データは2年で自動的に削除されます。'),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: InvoiceTable(
                        shopInvoiceProvider: shopInvoiceProvider,
                        invoices: _invoices,
                      ),
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

class AddInvoiceDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopInvoiceProvider shopInvoiceProvider;

  AddInvoiceDialog({
    @required this.shop,
    @required this.shopInvoiceProvider,
  });

  @override
  _AddInvoiceDialogState createState() => _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends State<AddInvoiceDialog> {
  DateTime openedAt = DateTime.now();
  DateTime closedAt = DateTime.now().add(Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '締日(期間)の新規登録',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('締日(期間)', style: kLabelTextStyle),
            SizedBox(height: 4.0),
            FillBoxFormButton(
              iconData: Icons.date_range,
              labelText:
                  '${DateFormat('yyyy/MM/dd').format(openedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(closedAt)}',
              labelColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: () async {
                final List<DateTime> selected =
                    await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: openedAt,
                  initialLastDate: closedAt,
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (selected != null && selected.length == 2) {
                  setState(() {
                    openedAt = selected.first;
                    closedAt = selected.last;
                  });
                }
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
                  iconData: Icons.check,
                  labelText: '登録する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.shopInvoiceProvider.create(
                        shopId: widget.shop?.id,
                        openedAt: openedAt,
                        closedAt: closedAt)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('締日(期間)を登録しました')),
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
