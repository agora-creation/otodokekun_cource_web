import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/shop_terms.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';

class ShopTermsTable extends StatefulWidget {
  final ShopModel shop;
  final ShopProvider shopProvider;

  ShopTermsTable({
    @required this.shop,
    @required this.shopProvider,
  });

  @override
  _ShopTermsTableState createState() => _ShopTermsTableState();
}

class _ShopTermsTableState extends State<ShopTermsTable> {
  void _init() {
    widget.shopProvider.clearController();
    widget.shopProvider.terms.text = widget.shop?.terms;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomTextField(
          controller: widget.shopProvider.terms,
          obscureText: false,
          textInputType: TextInputType.multiline,
          maxLines: null,
          labelText: '',
          iconData: Icons.short_text,
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            FillBoxButton(
              iconData: Icons.check,
              labelText: '保存する',
              labelColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              onTap: () async {
                if (!await widget.shopProvider.updateTerms()) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('利用規約を保存しました')),
                );
                widget.shopProvider.clearController();
                widget.shopProvider.reloadShopModel();
                Navigator.pushNamed(context, ShopTermsScreen.id);
              },
            ),
          ],
        ),
      ],
    );
  }
}
