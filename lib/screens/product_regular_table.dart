import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop_product_regular.dart';
import 'package:otodokekun_cource_web/providers/shop_product_regular.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';

class ProductRegularTable extends StatefulWidget {
  final ShopProductRegularProvider shopProductRegularProvider;
  final List<ShopProductRegularModel> productRegular;

  ProductRegularTable({
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditProductRegularDialog(
                          shopProductRegularProvider:
                              widget.shopProductRegularProvider,
                          productRegular: productRegular,
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

class EditProductRegularDialog extends StatefulWidget {
  final ShopProductRegularProvider shopProductRegularProvider;
  final ShopProductRegularModel productRegular;

  EditProductRegularDialog({
    @required this.shopProductRegularProvider,
    @required this.productRegular,
  });

  @override
  _EditProductRegularDialogState createState() =>
      _EditProductRegularDialogState();
}

class _EditProductRegularDialogState extends State<EditProductRegularDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '定期便の詳細',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('お届け日', style: kLabelTextStyle),
            Text(
                '${DateFormat('yyyy/MM/dd').format(widget.productRegular.deliveryAt)}'),
            SizedBox(height: 8.0),
            Text('商品名', style: kLabelTextStyle),
            Text('${widget.productRegular.productName}'),
            SizedBox(height: 8.0),
            Text('商品画像', style: kLabelTextStyle),
            widget.productRegular.productImage != ''
                ? Image.network(
                    widget.productRegular.productImage,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/noimage.png',
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 8.0),
            Text('単位', style: kLabelTextStyle),
            Text('${widget.productRegular.productUnit}'),
            SizedBox(height: 8.0),
            Text('価格', style: kLabelTextStyle),
            Text('¥ ${widget.productRegular.productPrice}'),
            SizedBox(height: 8.0),
            Text('商品説明', style: kLabelTextStyle),
            Text('¥ ${widget.productRegular.productDescription}'),
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
                  iconData: Icons.delete,
                  labelText: '削除する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  onTap: () async {
                    if (!await widget.shopProductRegularProvider.delete(
                        id: widget.productRegular.id,
                        shopId: widget.productRegular.shopId)) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('定期便を削除しました')),
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
