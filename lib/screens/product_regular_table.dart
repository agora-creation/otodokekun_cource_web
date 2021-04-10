import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_product_regular.dart';
import 'package:otodokekun_cource_web/providers/shop_product_regular.dart';

class ProductRegularTable extends StatefulWidget {
  final ShopModel shop;
  final ShopProductRegularProvider shopProductRegularProvider;
  final List<ShopProductRegularModel> productRegular;

  ProductRegularTable({
    @required this.shop,
    @required this.shopProductRegularProvider,
    @required this.productRegular,
  });

  @override
  _ProductRegularTableState createState() => _ProductRegularTableState();
}

class _ProductRegularTableState extends State<ProductRegularTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NativeDataTable.builder(
      columns: [
        DataColumn(label: Text('お届け日')),
        DataColumn(label: Text('商品名')),
        DataColumn(label: Text('価格')),
        DataColumn(label: Text('商品説明')),
        DataColumn(label: Text('詳細')),
      ],
      showSelect: false,
      rowsPerPage: _rowsPerPage,
      itemCount: widget.productRegular?.length ?? 0,
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
        final ShopProductRegularModel productRegular =
            widget.productRegular[index];
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(Text(
                '${DateFormat('yyyy/MM/dd').format(productRegular.deliveryAt)}')),
            DataCell(Text('${productRegular.productName}')),
            DataCell(Text('¥ ${productRegular.productPrice}')),
            DataCell(Text('${productRegular.productDescription}')),
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
