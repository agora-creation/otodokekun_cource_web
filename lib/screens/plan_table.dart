import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_plan.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_icon_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class PlanTable extends StatefulWidget {
  final ShopModel shop;
  final ShopPlanProvider shopPlanProvider;
  final List<Map<String, dynamic>> source;

  PlanTable({
    @required this.shop,
    @required this.shopPlanProvider,
    @required this.source,
  });

  @override
  _PlanTableState createState() => _PlanTableState();
}

class _PlanTableState extends State<PlanTable> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
      text: 'お届け日',
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
    DatatableHeader(
      text: '公開設定',
      value: 'publishedText',
      show: true,
      sortable: true,
    ),
  ];
  int _currentPerPage = 10;
  int _currentPage = 1;
  List<Map<String, dynamic>> _selecteds = [];
  String _sortColumn;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      title: '定期商品一覧',
      actions: [
        FillBoxButton(
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () {
            widget.shopPlanProvider.clearController();
            widget.shopPlanProvider.deliveryAt =
                DateTime.now().add(Duration(days: widget.shop.cancelLimit));
            showDialog(
              context: context,
              builder: (_) {
                return AddPlanDialog(
                  shop: widget.shop,
                  shopPlanProvider: widget.shopPlanProvider,
                );
              },
            );
          },
        ),
      ],
      headers: _headers,
      source: widget.source,
      selecteds: _selecteds,
      showSelect: false,
      onTabRow: (data) {
        widget.shopPlanProvider.clearController();
        widget.shopPlanProvider.name.text = data['name'];
        widget.shopPlanProvider.unit.text = data['unit'];
        widget.shopPlanProvider.price.text = data['price'].toString();
        widget.shopPlanProvider.description.text = data['description'];
        widget.shopPlanProvider.deliveryAt = data['deliveryAt'];
        widget.shopPlanProvider.published = data['published'];
        showDialog(
          context: context,
          builder: (_) {
            return EditPlanDialog(
              shopPlanProvider: widget.shopPlanProvider,
              data: data,
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

class AddPlanDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopPlanProvider shopPlanProvider;

  AddPlanDialog({
    @required this.shop,
    @required this.shopPlanProvider,
  });

  @override
  _AddPlanDialogState createState() => _AddPlanDialogState();
}

class _AddPlanDialogState extends State<AddPlanDialog> {
  Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '定期商品の新規登録',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopPlanProvider.name,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: '商品名',
              iconData: Icons.title,
            ),
            SizedBox(height: 8.0),
            Text('商品画像', style: kLabelTextStyle),
            GestureDetector(
              onTap: () {
                InputElement _input = FileUploadInputElement()
                  ..accept = 'image/*';
                _input.click();
                _input.onChange.listen((e) {
                  widget.shopPlanProvider.imageFile = _input.files.first;
                  final reader = FileReader();
                  reader.readAsDataUrl(widget.shopPlanProvider.imageFile);
                  reader.onLoadEnd.listen((e) {
                    final encoded = reader.result as String;
                    final stripped = encoded.replaceFirst(
                      RegExp(r'data:image/[^;]+;base64,'),
                      '',
                    );
                    setState(() {
                      imageData = base64.decode(stripped);
                    });
                  });
                });
              },
              child: imageData != null
                  ? Image.memory(
                      imageData,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/noimage.png',
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopPlanProvider.unit,
              obscureText: false,
              textInputType: null,
              maxLines: 1,
              labelText: '単位',
              iconData: Icons.ac_unit,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopPlanProvider.price,
              obscureText: false,
              textInputType: TextInputType.number,
              maxLines: 1,
              labelText: '価格',
              iconData: Icons.attach_money,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopPlanProvider.description,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: '説明',
              iconData: Icons.description,
            ),
            SizedBox(height: 8.0),
            Text('お届け日', style: kLabelTextStyle),
            SizedBox(height: 4.0),
            FillBoxIconButton(
              iconData: Icons.calendar_today,
              labelText:
                  '${DateFormat('yyyy/MM/dd').format(widget.shopPlanProvider.deliveryAt)}',
              labelColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: () async {
                var selected = await showDatePicker(
                  locale: const Locale('ja'),
                  context: context,
                  initialDate: widget.shopPlanProvider.deliveryAt,
                  firstDate: DateTime.now()
                      .add(Duration(days: widget.shop.cancelLimit)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (selected == null) return;
                setState(() {
                  widget.shopPlanProvider.deliveryAt = selected;
                });
              },
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
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopPlanProvider
                .create(shopId: widget.shop?.id)) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('登録が完了しました')),
            );
            widget.shopPlanProvider.clearController();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class EditPlanDialog extends StatefulWidget {
  final ShopPlanProvider shopPlanProvider;
  final dynamic data;

  EditPlanDialog({
    @required this.shopPlanProvider,
    @required this.data,
  });

  @override
  _EditPlanDialogState createState() => _EditPlanDialogState();
}

class _EditPlanDialogState extends State<EditPlanDialog> {
  Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.data['name']}の詳細',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopPlanProvider.name,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: '商品名',
              iconData: Icons.title,
            ),
            SizedBox(height: 8.0),
            Text('商品画像', style: kLabelTextStyle),
            GestureDetector(
              onTap: () {
                InputElement _input = FileUploadInputElement()
                  ..accept = 'image/*';
                _input.click();
                _input.onChange.listen((e) {
                  widget.shopPlanProvider.imageFile = _input.files.first;
                  final reader = FileReader();
                  reader.readAsDataUrl(widget.shopPlanProvider.imageFile);
                  reader.onLoadEnd.listen((e) {
                    final encoded = reader.result as String;
                    final stripped = encoded.replaceFirst(
                      RegExp(r'data:image/[^;]+;base64,'),
                      '',
                    );
                    setState(() {
                      imageData = base64.decode(stripped);
                    });
                  });
                });
              },
              child: imageData != null
                  ? Image.memory(
                      imageData,
                      fit: BoxFit.cover,
                    )
                  : widget.data['image'] != ''
                      ? Image.network(
                          widget.data['image'],
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/noimage.png',
                          fit: BoxFit.cover,
                        ),
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopPlanProvider.unit,
              obscureText: false,
              textInputType: null,
              maxLines: 1,
              labelText: '単位',
              iconData: Icons.ac_unit,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopPlanProvider.price,
              obscureText: false,
              textInputType: TextInputType.number,
              maxLines: 1,
              labelText: '価格',
              iconData: Icons.attach_money,
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: widget.shopPlanProvider.description,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: '説明',
              iconData: Icons.description,
            ),
            SizedBox(height: 8.0),
            Text('お届け日', style: kLabelTextStyle),
            SizedBox(height: 4.0),
            FillBoxIconButton(
              iconData: Icons.calendar_today,
              labelText:
                  '${DateFormat('yyyy/MM/dd').format(widget.shopPlanProvider.deliveryAt)}',
              labelColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              onTap: () async {
                var selected = await showDatePicker(
                  locale: const Locale('ja'),
                  context: context,
                  initialDate: widget.shopPlanProvider.deliveryAt,
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (selected == null) return;
                setState(() {
                  widget.shopPlanProvider.deliveryAt = selected;
                });
              },
            ),
            SizedBox(height: 8.0),
            DropdownButton<bool>(
              isExpanded: true,
              value: widget.shopPlanProvider.published,
              onChanged: (value) {
                setState(() {
                  widget.shopPlanProvider.published = value;
                });
              },
              items: [
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text('非公開'),
                ),
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text('公開'),
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
          labelText: '削除',
          labelColor: Colors.white,
          backgroundColor: Colors.redAccent,
          onTap: () async {
            if (!await widget.shopPlanProvider
                .delete(id: widget.data['id'], shopId: widget.data['shopId'])) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('削除が完了しました')),
            );
            widget.shopPlanProvider.clearController();
            Navigator.pop(context);
          },
        ),
        FillBoxButton(
          labelText: '変更を保存',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopPlanProvider
                .update(id: widget.data['id'], shopId: widget.data['shopId'])) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('変更が完了しました')),
            );
            widget.shopPlanProvider.clearController();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
