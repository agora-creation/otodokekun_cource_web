import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/screens/login.dart';
import 'package:otodokekun_cource_web/widgets/border_round_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/responsive_table.dart';

class UserScreen extends StatelessWidget {
  static const String id = 'user';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
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
                elevation: 1.0,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '顧客一覧',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FillBoxButton(
                        labelText: '顧客新規登録',
                        labelColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        onTap: () {
                          userProvider.initData();
                        },
                      ),
                    ),
                  ],
                  headers: userProvider.headers,
                  source: userProvider.source,
                  selecteds: userProvider.selecteds,
                  showSelect: userProvider.showSelect,
                  autoHeight: false,
                  onTabRow: (data) {
                    print(data);
                  },
                  onSort: (value) => userProvider.onSort(value),
                  sortAscending: userProvider.sortAscending,
                  sortColumn: userProvider.sortColumn,
                  isLoading: userProvider.isLoading,
                  onSelect: (value, item) => userProvider.onSelect(value, item),
                  onSelectAll: (value) => userProvider.onSelectAll(value),
                  footers: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('表示数:'),
                    ),
                    if (userProvider.perPages != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButton(
                          value: userProvider.currentPerPage,
                          items: userProvider.perPages
                              .map((e) => DropdownMenuItem(
                                    child: Text('$e'),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              userProvider.dropdownOnChanged(value),
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                          '${userProvider.currentPage} 〜 ${userProvider.currentPerPage} 全 ${userProvider.total} 件'),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => userProvider.backOnPressed(),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () => userProvider.forwardOnPressed(),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
