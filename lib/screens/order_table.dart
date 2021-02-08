import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/models/cart.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/widgets/border_round_button.dart';
import 'package:otodokekun_cource_web/widgets/cart_list_tile.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class OrderTable extends StatefulWidget {
  final ShopModel shop;
  final ShopOrderProvider shopOrderProvider;

  OrderTable({@required this.shop, @required this.shopOrderProvider});

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
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;

  void _getSource() async {
    setState(() => _isLoading = true);
    await widget.shopOrderProvider
        .getOrders(shopId: widget.shop?.id)
        .then((value) {
      _source = value;
      setState(() => _isLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _getSource();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      title: '注文一覧',
      actions: [],
      headers: _headers,
      source: _source,
      selecteds: _selecteds,
      showSelect: false,
      onTabRow: (data) {
        showDialog(
          context: context,
          builder: (_) {
            return OrderCustomDialog(
              shopOrderProvider: widget.shopOrderProvider,
              data: data,
              getSource: _getSource,
            );
          },
        );
      },
      onSort: (value) {
        setState(() {
          _sortColumn = value;
          _sortAscending = !_sortAscending;
          if (_sortAscending) {
            _source
                .sort((a, b) => b['$_sortColumn'].compareTo(a['$_sortColumn']));
          } else {
            _source
                .sort((a, b) => a['$_sortColumn'].compareTo(b['$_sortColumn']));
          }
        });
      },
      sortAscending: _sortAscending,
      sortColumn: _sortColumn,
      isLoading: _isLoading,
      onSelect: (value, item) {
        if (value) {
          setState(() => _selecteds.add(item));
        } else {
          setState(() => _selecteds.removeAt(_selecteds.indexOf(item)));
        }
      },
      onSelectAll: (value) {
        if (value) {
          setState(
              () => _selecteds = _source.map((entry) => entry).toList().cast());
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
      total: _source.length,
      currentPageBack: () {
        var _nextSet = _currentPage - _currentPerPage;
        setState(() {
          _currentPage = _nextSet > 1 ? _nextSet : 1;
        });
      },
      currentPageForward: () {
        var _nextSet = _currentPage + _currentPerPage;
        setState(() {
          _currentPage = _nextSet < _source.length ? _nextSet : _source.length;
        });
      },
    );
  }
}

class OrderCustomDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final dynamic data;
  final Function getSource;

  OrderCustomDialog({
    @required this.shopOrderProvider,
    @required this.data,
    this.getSource,
  });

  @override
  _OrderCustomDialogState createState() => _OrderCustomDialogState();
}

class _OrderCustomDialogState extends State<OrderCustomDialog> {
  @override
  Widget build(BuildContext context) {
    List<CartModel> cart = widget.data['cart'];
    return CustomDialog(
      title: '注文詳細',
      content: Container(
        width: 400.0,
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
                        child: Text('配達状況'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('${widget.data['shippingText']}'),
                      ),
                    ),
                  ],
                ),
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
              ],
            ),
          ],
        ),
      ),
      actions: [
        widget.data['shipping']
            ? BorderRoundButton(
                labelText: '配達待ちにする',
                labelColor: Colors.blueAccent,
                borderColor: Colors.blueAccent,
                onTap: () async {
                  if (!await widget.shopOrderProvider.updateOrder(
                      id: widget.data['id'],
                      shopId: widget.data['shopId'],
                      shipping: widget.data['shipping'])) {
                    return;
                  }
                  widget.getSource();
                  Navigator.pop(context);
                },
              )
            : FillRoundButton(
                labelText: '配達済みにする',
                labelColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                onTap: () async {
                  if (!await widget.shopOrderProvider.updateOrder(
                      id: widget.data['id'],
                      shopId: widget.data['shopId'],
                      shipping: widget.data['shipping'])) {
                    return;
                  }
                  widget.getSource();
                  Navigator.pop(context);
                },
              ),
      ],
    );
  }
}
