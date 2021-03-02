import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/cart.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_staff.dart';
import 'package:otodokekun_cource_web/providers/shop_order.dart';
import 'package:otodokekun_cource_web/providers/shop_staff.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/cart_list_tile.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
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
  List<ShopStaffModel> _staffs = [];

  void _init() async {
    await widget.shopStaffProvider
        .selectList(shopId: widget.shop?.id)
        .then((value) {
      _staffs = value;
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
        BorderBoxButton(
          labelText: '検索',
          labelColor: Colors.blueAccent,
          borderColor: Colors.blueAccent,
          onTap: () {},
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
            SizedBox(height: 8.0),
            Text('配達状況', style: kLabelTextStyle),
            DropdownButton(
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
          ],
        ),
      ),
      actions: [
        BorderBoxButton(
          labelText: '閉じる',
          labelColor: Colors.blueAccent,
          borderColor: Colors.blueAccent,
          onTap: () => Navigator.pop(context),
        ),
        FillBoxButton(
          labelText: '変更を保存',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopOrderProvider
                .update(id: widget.data['id'], shopId: widget.data['shopId'])) {
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
