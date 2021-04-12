import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/models/shop.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/shop.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';

class ShopTable extends StatefulWidget {
  final ShopModel shop;
  final ShopProvider shopProvider;

  ShopTable({
    @required this.shop,
    @required this.shopProvider,
  });

  @override
  _ShopTableState createState() => _ShopTableState();
}

class _ShopTableState extends State<ShopTable> {
  List<int> _cancelLimitList = [3, 4, 5, 6, 7];
  int _cancelLimit;

  void _init() {
    widget.shopProvider.clearController();
    widget.shopProvider.code.text = widget.shop?.code;
    widget.shopProvider.name.text = widget.shop?.name;
    widget.shopProvider.zip.text = widget.shop?.zip;
    widget.shopProvider.address.text = widget.shop?.address;
    widget.shopProvider.tel.text = widget.shop?.tel;
    widget.shopProvider.email.text = widget.shop?.email;
    widget.shopProvider.remarks.text = widget.shop?.remarks;
    _cancelLimit = widget.shop?.cancelLimit;
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
          controller: widget.shopProvider.code,
          obscureText: false,
          textInputType: null,
          maxLines: 1,
          labelText: '店舗コード',
          iconData: Icons.vpn_key,
        ),
        Text(
          '※顧客がスマホで利用する際に必要な情報です。',
          style: TextStyle(color: Colors.redAccent),
        ),
        SizedBox(height: 8.0),
        CustomTextField(
          controller: widget.shopProvider.name,
          obscureText: false,
          textInputType: TextInputType.name,
          maxLines: 1,
          labelText: '店舗名',
          iconData: Icons.store,
        ),
        SizedBox(height: 8.0),
        CustomTextField(
          controller: widget.shopProvider.zip,
          obscureText: false,
          textInputType: null,
          maxLines: 1,
          labelText: '郵便番号',
          iconData: Icons.location_pin,
        ),
        SizedBox(height: 8.0),
        CustomTextField(
          controller: widget.shopProvider.address,
          obscureText: false,
          textInputType: TextInputType.streetAddress,
          maxLines: 1,
          labelText: '住所',
          iconData: Icons.business,
        ),
        SizedBox(height: 8.0),
        CustomTextField(
          controller: widget.shopProvider.tel,
          obscureText: false,
          textInputType: TextInputType.phone,
          maxLines: 1,
          labelText: '電話番号',
          iconData: Icons.phone,
        ),
        SizedBox(height: 8.0),
        CustomTextField(
          controller: widget.shopProvider.email,
          obscureText: false,
          textInputType: TextInputType.emailAddress,
          maxLines: 1,
          labelText: 'メールアドレス',
          iconData: Icons.email,
        ),
        SizedBox(height: 8.0),
        CustomTextField(
          controller: widget.shopProvider.remarks,
          obscureText: false,
          textInputType: TextInputType.multiline,
          maxLines: null,
          labelText: '店舗説明',
          iconData: Icons.short_text,
        ),
        SizedBox(height: 8.0),
        Text('キャンセル期限日', style: kLabelTextStyle),
        DropdownButton<int>(
          isExpanded: true,
          value: _cancelLimit,
          onChanged: (value) {
            setState(() {
              _cancelLimit = value;
            });
          },
          items: _cancelLimitList.map((value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value日前'),
            );
          }).toList(),
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
                if (!await widget.shopProvider
                    .updateInfo(cancelLimit: _cancelLimit)) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('店舗情報を保存しました')),
                );
                widget.shopProvider.clearController();
                widget.shopProvider.reloadShopModel();
                Navigator.pushNamed(context, ShopScreen.id);
              },
            ),
          ],
        ),
      ],
    );
  }
}
