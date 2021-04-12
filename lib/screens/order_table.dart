import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/cart.dart';
import 'package:otodokekun_cource_web/models/shop_order.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/cart_list_tile.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';

class OrderTable extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final List<ShopOrderModel> orders;
  final List<ShopStaffModel> staffs;

  OrderTable({
    @required this.shopOrderProvider,
    @required this.orders,
    @required this.staffs,
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
            DataCell(order.cart.length > 1
                ? Text('${order.cart[0].name} 他')
                : Text('${order.cart[0].name}')),
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditOrderDialog(
                          shopOrderProvider: widget.shopOrderProvider,
                          order: order,
                          staffs: widget.staffs,
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

class EditOrderDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final ShopOrderModel order;
  final List<ShopStaffModel> staffs;

  EditOrderDialog({
    @required this.shopOrderProvider,
    @required this.order,
    @required this.staffs,
  });

  @override
  _EditOrderDialogState createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  List<CartModel> _cart = [];
  List<String> _staffNames = [];
  String _staff;

  @override
  void initState() {
    super.initState();
    _cart = widget.order.cart;
    for (ShopStaffModel staff in widget.staffs) {
      _staffNames.add(staff.name);
    }
    _staffNames.insert(0, '');
    _staff = widget.order.staff;
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
              itemCount: _cart.length,
              itemBuilder: (_, index) {
                return CartListTile(
                  name: _cart[index].name,
                  image: _cart[index].image,
                  unit: _cart[index].unit,
                  price: _cart[index].price,
                  quantity: _cart[index].quantity,
                );
              },
            ),
            Text('注文日時', style: kLabelTextStyle),
            Text(
                '${DateFormat('yyyy/MM/dd HH:mm').format(widget.order.createdAt)}'),
            SizedBox(height: 8.0),
            Text('お届け日', style: kLabelTextStyle),
            Text('${DateFormat('yyyy/MM/dd').format(widget.order.deliveryAt)}'),
            SizedBox(height: 8.0),
            Text('注文者', style: kLabelTextStyle),
            Text('${widget.order.userName}'),
            SizedBox(height: 8.0),
            Text('お届け先', style: kLabelTextStyle),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('〒${widget.order.userZip}'),
                Text('${widget.order.userAddress}'),
                Text('${widget.order.userTel}'),
              ],
            ),
            SizedBox(height: 8.0),
            Text('備考', style: kLabelTextStyle),
            Text('${widget.order.remarks}'),
            SizedBox(height: 8.0),
            Text('合計金額', style: kLabelTextStyle),
            Text('¥ ${widget.order.totalPrice}'),
            SizedBox(height: 8.0),
            Text('担当者', style: kLabelTextStyle),
            DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              value: _staff,
              onChanged: (value) {
                setState(() {
                  _staff = value;
                });
              },
              items: _staffNames.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
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
                widget.order.shipping
                    ? Container()
                    : BorderBoxButton(
                        iconData: Icons.cancel_outlined,
                        labelText: 'キャンセル',
                        labelColor: Colors.redAccent,
                        borderColor: Colors.redAccent,
                        onTap: () async {
                          if (!await widget.shopOrderProvider.delete(
                              id: widget.order.id,
                              shopId: widget.order.shopId)) {
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('注文をキャンセルしました')),
                          );
                          Navigator.pop(context);
                        },
                      ),
                SizedBox(width: 4.0),
                widget.order.shipping
                    ? Container()
                    : FillBoxButton(
                        iconData: Icons.local_shipping,
                        labelText: '配達完了',
                        labelColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        onTap: () async {
                          if (!await widget.shopOrderProvider.updateShipping(
                              id: widget.order.id,
                              shopId: widget.order.shopId,
                              userId: widget.order.userId,
                              staff: _staff)) {
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('配達が完了しました')),
                          );
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
                    if (!await widget.shopOrderProvider.update(
                        id: widget.order.id,
                        shopId: widget.order.shopId,
                        userId: widget.order.userId,
                        staff: _staff)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('注文を保存しました')),
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
