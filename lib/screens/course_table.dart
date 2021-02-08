import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/shop_course.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/days_list_tile.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:responsive_table/DatatableHeader.dart';

class CourseTable extends StatefulWidget {
  final ShopModel shop;
  final ShopCourseProvider shopCourseProvider;

  CourseTable({@required this.shop, @required this.shopCourseProvider});

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
      text: '開始日',
      value: 'openedAtText',
      show: true,
      sortable: true,
    ),
    DatatableHeader(
      text: '終了日',
      value: 'closedAt',
      show: false,
      sortable: false,
    ),
    DatatableHeader(
      text: '終了日',
      value: 'closedAtText',
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
      text: '公開設定',
      value: 'published',
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
    await widget.shopCourseProvider
        .getCourses(shopId: widget.shop?.id)
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
                  getSource: _getSource,
                );
              },
            );
          },
        ),
      ],
      headers: _headers,
      source: _source,
      selecteds: _selecteds,
      showSelect: true,
      onTabRow: (data) {
        widget.shopCourseProvider.clearController();
        widget.shopCourseProvider.name.text = data['name'];
        showDialog(
          context: context,
          builder: (_) {
            return CourseCustomDialog(
              shopCourseProvider: widget.shopCourseProvider,
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

class AddCourseCustomDialog extends StatefulWidget {
  final ShopModel shop;
  final ShopCourseProvider shopCourseProvider;
  final Function getSource;

  AddCourseCustomDialog({
    @required this.shop,
    @required this.shopCourseProvider,
    this.getSource,
  });

  @override
  _AddCourseCustomDialogState createState() => _AddCourseCustomDialogState();
}

class _AddCourseCustomDialogState extends State<AddCourseCustomDialog> {
  DateTime openedAt;
  DateTime closedAt;
  String rangeText;
  List<DateTime> days = [];

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '新規登録',
      content: Container(
        width: 400.0,
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
              labelText: rangeText == null ? '日付範囲選択' : rangeText,
              labelColor: Colors.white,
              backgroundColor: Colors.grey,
              onTap: () async {
                DateTime now = DateTime.now();
                final List<DateTime> picked =
                    await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: now,
                  initialLastDate: now.add(Duration(days: 7)),
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2022),
                );
                if (picked != null && picked.length == 2) {
                  setState(() {
                    openedAt = picked.first;
                    closedAt = picked.last;
                    rangeText =
                        '${DateFormat('yyyy/MM/dd').format(openedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(closedAt)}';
                    days = _calculateDaysInterval(openedAt, closedAt);
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
                return DaysListTile();
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
            if (!await widget.shopCourseProvider
                .createCourse(shopId: widget.shop?.id)) {
              return;
            }
            widget.shopCourseProvider.clearController();
            widget.getSource();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class CourseCustomDialog extends StatefulWidget {
  final ShopCourseProvider shopCourseProvider;
  final dynamic data;
  final Function getSource;

  CourseCustomDialog({
    @required this.shopCourseProvider,
    @required this.data,
    this.getSource,
  });

  @override
  _CourseCustomDialogState createState() => _CourseCustomDialogState();
}

class _CourseCustomDialogState extends State<CourseCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.data['name']}',
      content: Container(
        width: 400.0,
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
            widget.shopCourseProvider.clearController();
            widget.getSource();
            Navigator.pop(context);
          },
        ),
        FillRoundButton(
          labelText: '変更を保存',
          labelColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          onTap: () async {
            if (!await widget.shopCourseProvider.updateCourse(
                id: widget.data['id'], shopId: widget.data['shopId'])) {
              return;
            }
            widget.shopCourseProvider.clearController();
            widget.getSource();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

List<DateTime> _calculateDaysInterval(DateTime openedAt, DateTime closedAt) {
  List<DateTime> days = [];
  for (int i = 0; i <= closedAt.difference(openedAt).inDays; i++) {
    days.add(openedAt.add(Duration(days: i)));
  }
  return days;
}
