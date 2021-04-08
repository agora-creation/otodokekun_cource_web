import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  static const String id = 'report';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: ReportTable(),
    );
  }
}

class ReportTable extends StatefulWidget {
  @override
  _ReportTableState createState() => _ReportTableState();
}

class _ReportTableState extends State<ReportTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Text(
            '集計',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
