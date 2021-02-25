import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:otodokekun_cource_web/models/cart.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/widgets/cart_list_tile.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_icon_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class OrderTable extends StatefulWidget {
  final ShopModel shop;
  final ShopOrderProvider shopOrderProvider;
  final ShopStaffProvider shopStaffProvider;
  final List<Map<String, dynamic>> source;

  OrderTable({
    @required this.shop,
    @required this.shopOrderProvider,
    @required this.shopStaffProvider,
    @required this.source,
  });

  @override
  _OrderTableState createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
      text: 'ID',
      value: 'id',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '店舗ID',
      value: 'shopId',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '顧客ID',
      value: 'userId',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '顧客名',
      value: 'name',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '郵便番号',
      value: 'zip',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '住所',
      value: 'address',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '電話番号',
      value: 'tel',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: 'カート',
      value: 'cart',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: 'お届け予定日',
      value: 'deliveryAt',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: 'お届け予定日',
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
      value: 'shipping',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '配達状況',
      value: 'shippingText',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '登録日時',
      value: 'createdAt',
      show: false,
      sortable: false,
    ),
  ];
  int _currentPerPage = 10;
  int _currentPage = 1;
  List<Map<String, dynamic>> _selecteds = [];
  String _sortColumn;
  bool _sortAscending = true;
  List<ShopStaffModel> _staffs = [];
  DateTime selectMonth = DateTime.now();
  DateTime firstDate = DateTime(DateTime.now().year - 1);
  DateTime lastDate = DateTime(DateTime.now().year + 1);
  String selectShipping = '配達待ち';

  void _getStaff() async {
    await widget.shopStaffProvider
        .getStaffs(shopId: widget.shop?.id)
        .then((value) {
      _staffs = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _getStaff();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      title: '注文一覧',
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '表示期間',
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
                FillBoxIconButton(
                  iconData: Icons.calendar_today,
                  labelText: '${DateFormat('yyyy年MM月').format(selectMonth)}',
                  labelColor: Colors.white,
                  backgroundColor: Colors.lightBlueAccent,
                  onTap: () async {
                    var selected = await showMonthPicker(
                      context: context,
                      initialDate: selectMonth,
                      firstDate: firstDate,
                      lastDate: lastDate,
                    );
                    if (selected == null) return;
                    setState(() {
                      selectMonth = selected;
                    });
                  },
                ),
              ],
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '配達状況',
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
                DropdownButton<String>(
                  value: selectShipping,
                  onChanged: (value) {
                    setState(() {
                      selectShipping = value;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: '配達待ち',
                      child: Text('配達待ち'),
                    ),
                    DropdownMenuItem(
                      value: '配達済み',
                      child: Text('配達済み'),
                    ),
                  ],
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
        widget.shopOrderProvider.shipping = data['shipping'];
        showDialog(
          context: context,
          builder: (_) {
            return EditOrderCustomDialog(
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

class EditOrderCustomDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final dynamic data;
  final List<ShopStaffModel> staffs;

  EditOrderCustomDialog({
    @required this.shopOrderProvider,
    @required this.data,
    @required this.staffs,
  });

  @override
  _EditOrderCustomDialogState createState() => _EditOrderCustomDialogState();
}

class _EditOrderCustomDialogState extends State<EditOrderCustomDialog> {
  List<String> staffs = [];

  void _createStaff() {
    for (ShopStaffModel staff in widget.staffs) {
      staffs.add(staff.name);
    }
  }

  @override
  void initState() {
    super.initState();
    _createStaff();
    staffs.insert(0, '');
  }

  @override
  Widget build(BuildContext context) {
    List<CartModel> cart = widget.data['cart'];
    return CustomDialog(
      title: '注文詳細',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('注文商品'),
            SizedBox(height: 4.0),
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
            Table(
              border: TableBorder.all(width: 1.0, color: Colors.black54),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('注文日時'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${DateFormat('yyyy/MM/dd HH:mm').format(widget.data['createdAt'])}',
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('顧客名'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('${widget.data['name']}'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('住所'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('〒${widget.data['zip']}'),
                            Text('${widget.data['address']}'),
                            Text('${widget.data['tel']}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('お届け予定日'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('${widget.data['deliveryAtText']}'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('備考'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('${widget.data['remarks']}'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('合計金額'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('${widget.data['totalPrice']}'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('担当者'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
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
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('配達状況'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DropdownButton(
                          isExpanded: true,
                          value: widget.shopOrderProvider.shipping,
                          onChanged: (value) {
                            setState(() {
                              widget.shopOrderProvider.shipping = value;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: false,
                              child: Text('配達待ち'),
                            ),
                            DropdownMenuItem(
                              value: true,
                              child: Text('配達済み'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        FillRoundButton(
          labelText: '変更を保存',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopOrderProvider.updateOrder(
                id: widget.data['id'], shopId: widget.data['shopId'])) {
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
