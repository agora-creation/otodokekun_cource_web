import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/widgets/custom_admin_scaffold.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';
import 'package:provider/provider.dart';

class ReportUserScreen extends StatelessWidget {
  static const String id = 'report_user';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return CustomAdminScaffold(
      shop: shopProvider.shop,
      selectedRoute: id,
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kSubColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('集計 - 顧客毎', style: TextStyle(fontSize: 18.0)),
                  FillBoxButton(
                    iconData: Icons.file_download,
                    labelText: 'CSVダウンロード',
                    labelColor: Colors.white,
                    backgroundColor: Colors.teal,
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Text('顧客毎の集計を見ることができます。締日(期間)で検索し、表示してください。'),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
