import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/app.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/providers/user.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/custom_table.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const String id = 'user';

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return CustomAdminScaffold(
      appProvider: appProvider,
      shopProvider: shopProvider,
      selectedRoute: id,
      body: CustomTable(
        title: '顧客一覧',
        actions: [
          Row(
            children: [
              FillBoxButton(
                labelText: '顧客新規登録',
                labelColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                onTap: () {},
              ),
            ],
          ),
        ],
        headers: userProvider.headers,
        source: userProvider.users,
        selecteds: userProvider.selecteds,
        onSort: (value) => userProvider.onSort(value),
        sortAscending: userProvider.sortAscending,
        sortColumn: userProvider.sortColumn,
        isLoading: userProvider.isLoading,
        onSelect: (value, item) => userProvider.onSelect(value, item),
        onSelectAll: (value) => userProvider.onSelectAll(value),
        currentPerPageChange: (value) =>
            userProvider.currentPerPageChange(value),
        currentPage: userProvider.currentPage,
        currentPerPage: userProvider.currentPerPage,
        total: userProvider.users.length,
        currentPageBack: userProvider.currentPageBack,
        currentPageForward: userProvider.currentPageForward,
      ),
    );
  }
}
