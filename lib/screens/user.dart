import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/login.dart';
import 'package:otodokekun_cource_web/widgets/border_round_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/responsive_table.dart';

class UserScreen extends StatelessWidget {
  static const String id = 'user';

  List<int> _perPages = [10, 50, 100];
  int _total = 100;
  int _currentPerPage;
  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];


  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    return CustomAdminScaffold(
      title: shopProvider.shop?.name ?? '',
      actions: [
        IconButton(
          icon: Icon(Icons.store),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('店舗情報'),
                  actions: [
                    BorderRoundButton(
                      labelText: 'ログアウト',
                      labelColor: Colors.blueAccent,
                      borderColor: Colors.blueAccent,
                      onTap: () {
                        shopProvider.signOut();
                        shopProvider.clearController();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
      selectedRoute: id,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(0.0),
              constraints: BoxConstraints(maxHeight: 700.0),
              child: Card(
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: Text('顧客一覧'),
                  actions: [],
                  headers: [
                    DatatableHeader(text: '名前'),
                    DatatableHeader(text: '電話番号'),
                    DatatableHeader(text: 'メールアドレス'),
                    DatatableHeader(text: 'パスワード'),
                    DatatableHeader(text: '登録日時'),
                  ],
                  source: [],
                  selecteds: [],
                  showSelect: true,
                  autoHeight: false,
                  onTabRow: (data) {
                    print(data);
                  },
                  onSort: (value) {},
                  sortAscending: true,
                  sortColumn: '',
                  isLoading: true,
                  onSelect: (value, item) {},
                  onSelectAll: (value) {},
                  footers: [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
