import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/user.dart';
import 'package:otodokekun_cource_web/providers/shop_product_regular.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class PlanTable extends StatefulWidget {
  final ShopModel shop;
  final ShopProductRegularProvider shopPlanProvider;
  final UserProvider userProvider;
  final List<Map<String, dynamic>> source;

  PlanTable({
    @required this.shop,
    @required this.shopPlanProvider,
    @required this.userProvider,
    @required this.source,
  });

  @override
  _PlanTableState createState() => _PlanTableState();
}

class _PlanTableState extends State<PlanTable> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
      text: 'お届け指定日',
      value: 'deliveryAtText',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '商品名',
      value: 'name',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '価格',
      value: 'price',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '説明',
      value: 'description',
      show: true,
      sortable: true,
    ),
  ];
  int _currentPerPage = 10;
  int _currentPage = 1;
  List<Map<String, dynamic>> _selecteds = [];
  String _sortColumn;
  bool _sortAscending = true;
  List<UserModel> _users = [];

  void _init() async {
    await widget.userProvider
        .selectListFixed(shopId: widget.shop?.id)
        .then((value) {
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
      title: '定期商品一覧',
      actions: [
        FillBoxButton(
          iconData: Icons.add,
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () {
            widget.shopPlanProvider.deliveryAt =
                DateTime.now().add(Duration(days: widget.shop.cancelLimit));
          },
        ),
      ],
      headers: _headers,
      source: widget.source,
      selecteds: _selecteds,
      showSelect: false,
      onTabRow: (data) {},
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

// class EditPlanDialog extends StatefulWidget {
//   final ShopProductRegularProvider shopPlanProvider;
//   final dynamic data;
//
//   EditPlanDialog({
//     @required this.shopPlanProvider,
//     @required this.data,
//   });
//
//   @override
//   _EditPlanDialogState createState() => _EditPlanDialogState();
// }
//
// class _EditPlanDialogState extends State<EditPlanDialog> {
//   Uint8List imageData;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomDialog(
//       title: '${widget.data['name']}の詳細',
//       content: Container(
//         width: 450.0,
//         child: ListView(
//           shrinkWrap: true,
//           children: [
//             Text('商品名', style: kLabelTextStyle),
//             Text('${widget.data['name']}'),
//             SizedBox(height: 8.0),
//             Text('商品画像', style: kLabelTextStyle),
//             GestureDetector(
//               onTap: () {},
//               child: imageData != null
//                   ? Image.memory(
//                       imageData,
//                       fit: BoxFit.cover,
//                     )
//                   : widget.data['image'] != ''
//                       ? Image.network(
//                           widget.data['image'],
//                           fit: BoxFit.cover,
//                         )
//                       : Image.asset(
//                           'assets/images/noimage.png',
//                           fit: BoxFit.cover,
//                         ),
//             ),
//             SizedBox(height: 8.0),
//             Text('単位', style: kLabelTextStyle),
//             Text('${widget.data['unit']}'),
//             SizedBox(height: 8.0),
//             Text('価格', style: kLabelTextStyle),
//             Text('¥ ${widget.data['price']}'),
//             SizedBox(height: 8.0),
//             Text('説明', style: kLabelTextStyle),
//             Text('${widget.data['description']}'),
//             SizedBox(height: 8.0),
//             Text('お届け指定日', style: kLabelTextStyle),
//             Text('${widget.data['deliveryAtText']}'),
//             SizedBox(height: 16.0),
//             Divider(height: 0.0),
//             SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 BorderBoxButton(
//                   iconData: Icons.close,
//                   labelText: '閉じる',
//                   labelColor: Colors.blueGrey,
//                   borderColor: Colors.blueGrey,
//                   onTap: () => Navigator.pop(context),
//                 ),
//                 SizedBox(width: 4.0),
//                 FillBoxButton(
//                   iconData: Icons.delete,
//                   labelText: '削除',
//                   labelColor: Colors.white,
//                   backgroundColor: Colors.redAccent,
//                   onTap: () async {
//                     if (!await widget.shopPlanProvider.delete(
//                         id: widget.data['id'], shopId: widget.data['shopId'])) {
//                       return;
//                     }
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('定期商品情報を削除しました')),
//                     );
//                     widget.shopPlanProvider.clearController();
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
