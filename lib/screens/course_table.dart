import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/days.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/models/shop_product.dart';
import 'package:otodokekun_cource_web/providers/shop_course.dart';
import 'package:otodokekun_cource_web/providers/shop_product.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/days_list_tile.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

import '../models/days.dart';
import '../models/shop_product.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/days_list_tile.dart';
import '../widgets/fill_round_button.dart';

class CourseTable extends StatefulWidget {
  final ShopModel shop;
  final ShopCourseProvider shopCourseProvider;
  final ShopProductProvider shopProductProvider;
  final List<Map<String, dynamic>> source;

  CourseTable({
    @required this.shop,
    @required this.shopCourseProvider,
    @required this.shopProductProvider,
    @required this.source,
  });

  @override
  _CourseTableState createState() => _CourseTableState();
}

class _CourseTableState extends State<CourseTable> {
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
      text: 'コース(セット)名',
      value: 'name',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '開始日',
      value: 'openedAt',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '終了日',
      value: 'closedAt',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: 'コース期間',
      value: 'openedClosed',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: 'DAYS',
      value: 'days',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '商品(一部)',
      value: 'daysText',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '公開設定',
      value: 'published',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '公開設定',
      value: 'publishedText',
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
  List<ShopProductModel> _products = [];

  void _getProduct() async {
    await widget.shopProductProvider
        .getProducts(shopId: widget.shop?.id)
        .then((value) {
      _products = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      title: 'コース(セット)商品一覧',
      actions: [
        FillBoxButton(
          labelText: '新規登録',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () {
            widget.shopCourseProvider.clearController();
            showDialog(
              context: context,
              builder: (_) {
                return AddCourseCustomDialog(
                  shop: widget.shop,
                  shopCourseProvider: widget.shopCourseProvider,
                  products: _products,
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
        widget.shopCourseProvider.clearController();
        widget.shopCourseProvider.name.text = data['name'];
        showDialog(
          context: context,
          builder: (_) {
            return EditCourseCustomDialog(
              shopCourseProvider: widget.shopCourseProvider,
              data: data,
              products: _products,
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

class AddCourseCustomDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopCourseProvider shopCourseProvider;
  final List<ShopProductModel> products;

  AddCourseCustomDialog({
    @required this.shop,
    @required this.shopCourseProvider,
    @required this.products,
  });

  @override
  _AddCourseCustomDialogState createState() => _AddCourseCustomDialogState();
}

class _AddCourseCustomDialogState extends State<AddCourseCustomDialog> {
  DateTime openedAt;
  DateTime closedAt;
  DateTime initialFirstDate = DateTime.now();
  DateTime initialLastDate = DateTime.now().add(Duration(days: 5));
  DateTime firstDate = DateTime.now().subtract(Duration(days: 365));
  DateTime lastDate = DateTime.now().add(Duration(days: 365));
  List<DaysModel> days = [];
  List<ShopProductModel> products = [];

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '新規登録',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopCourseProvider.name,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: 'コース(セット)名',
              iconData: Icons.title,
            ),
            SizedBox(height: 8.0),
            FillBoxButton(
              labelText: '日付範囲選択',
              labelColor: Colors.white,
              backgroundColor: Colors.grey,
              onTap: () async {
                final List<DateTime> picked =
                    await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: initialFirstDate,
                  initialLastDate: initialLastDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );
                if (picked != null && picked.length == 2) {
                  setState(() {
                    openedAt = picked.first;
                    closedAt = picked.last;
                    initialFirstDate = picked.first;
                    initialLastDate = picked.last;
                    days.clear();
                    days = createDays(openedAt, closedAt);
                    products = []..length = days.length;
                  });
                }
              },
            ),
            SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: days.length,
              itemBuilder: (_, index) {
                return DaysListTile(
                  deliveryAt: days[index].deliveryAt,
                  child: DropdownButton<ShopProductModel>(
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    value: products[index],
                    onChanged: (product) {
                      setState(() {
                        days[index].id = product.id;
                        days[index].name = product.name;
                        days[index].image = product.image;
                        days[index].unit = product.unit;
                        days[index].price = product.price;
                        days[index].exist = true;
                        products[index] = product;
                      });
                    },
                    items: widget.products.map((product) {
                      return DropdownMenuItem<ShopProductModel>(
                        value: product,
                        child: Text('${product.name}'),
                      );
                    }).toList(),
                  ),
                  onTap: () {
                    setState(() {
                      products[index] = null;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        FillRoundButton(
          labelText: '登録する',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopCourseProvider.createCourse(
                shopId: widget.shop?.id,
                openedAt: openedAt,
                closedAt: closedAt,
                days: days)) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('登録が完了しました')),
            );
            widget.shopCourseProvider.clearController();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class EditCourseCustomDialog extends StatefulWidget {
  final ShopCourseProvider shopCourseProvider;
  final dynamic data;
  final List<ShopProductModel> products;

  EditCourseCustomDialog({
    @required this.shopCourseProvider,
    @required this.data,
    @required this.products,
  });

  @override
  _EditCourseCustomDialogState createState() => _EditCourseCustomDialogState();
}

class _EditCourseCustomDialogState extends State<EditCourseCustomDialog> {
  List<DaysModel> days = [];
  List<ShopProductModel> selecteds = [];

  @override
  void initState() {
    super.initState();
    days = widget.data['days'];
    selecteds = []..length = days.length;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.data['name']}',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopCourseProvider.name,
              obscureText: false,
              textInputType: TextInputType.name,
              maxLines: 1,
              labelText: 'コース(セット)名',
              iconData: Icons.title,
            ),
            SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: days.length,
              itemBuilder: (_, index) {
                return DaysListTile(
                  deliveryAt: days[index].deliveryAt,
                  child: DropdownButton<ShopProductModel>(
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    value: selecteds[index],
                    onChanged: (product) {
                      setState(() {
                        selecteds[index] = product;
                      });
                    },
                    items: widget.products.map((product) {
                      return DropdownMenuItem<ShopProductModel>(
                        value: product,
                        child: Text('${product.name}'),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        FillRoundButton(
          labelText: '削除する',
          labelColor: Colors.white,
          backgroundColor: Colors.redAccent,
          onTap: () async {
            if (!await widget.shopCourseProvider.deleteCourse(
                id: widget.data['id'], shopId: widget.data['shopId'])) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('削除が完了しました')),
            );
            widget.shopCourseProvider.clearController();
            Navigator.pop(context);
          },
        ),
        FillRoundButton(
          labelText: '変更を保存',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopCourseProvider.updateCourse(
                id: widget.data['id'],
                shopId: widget.data['shopId'],
                days: days)) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('変更が完了しました')),
            );
            widget.shopCourseProvider.clearController();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
