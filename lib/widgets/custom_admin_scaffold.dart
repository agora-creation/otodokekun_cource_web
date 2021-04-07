import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:otodokekun_cource_web/helpers/side_menu.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/login.dart';
import 'package:otodokekun_cource_web/widgets/border_box_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_dialog.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_box_button.dart';

class CustomAdminScaffold extends StatelessWidget {
  final ShopProvider shopProvider;
  final String selectedRoute;
  final Widget body;

  CustomAdminScaffold({
    @required this.shopProvider,
    @required this.selectedRoute,
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          shopProvider.shop?.name ?? '',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Tooltip(
            message: '利用規約の編集',
            child: IconButton(
              icon: Icon(Icons.description),
              onPressed: () {
                shopProvider.clearController();
                shopProvider.terms.text = shopProvider.shop?.terms;
                showDialog(
                  context: context,
                  builder: (_) {
                    return EditShopTermsDialog(shopProvider: shopProvider);
                  },
                );
              },
            ),
          ),
          Tooltip(
            message: '店舗説明',
            child: IconButton(
              icon: Icon(Icons.comment),
              onPressed: () {
                shopProvider.clearController();
                shopProvider.remarks.text = shopProvider.shop?.remarks;
                showDialog(
                  context: context,
                  builder: (_) {
                    return EditShopRemarksDialog(shopProvider: shopProvider);
                  },
                );
              },
            ),
          ),
          Tooltip(
            message: '店鋪情報の編集',
            child: IconButton(
              icon: Icon(Icons.store),
              onPressed: () {
                shopProvider.clearController();
                shopProvider.code.text = shopProvider.shop?.code;
                shopProvider.name.text = shopProvider.shop?.name;
                shopProvider.zip.text = shopProvider.shop?.zip;
                shopProvider.address.text = shopProvider.shop?.address;
                shopProvider.tel.text = shopProvider.shop?.tel;
                shopProvider.email.text = shopProvider.shop?.email;
                shopProvider.cancelLimit = shopProvider.shop?.cancelLimit;
                showDialog(
                  context: context,
                  builder: (_) {
                    return EditShopDialog(shopProvider: shopProvider);
                  },
                );
              },
            ),
          ),
        ],
      ),
      sideBar: SideBar(
        activeIconColor: Colors.white,
        activeTextStyle: TextStyle(color: Colors.white),
        activeBackgroundColor: kSubColor.withOpacity(0.8),
        textStyle: TextStyle(color: kSubColor),
        items: kSideMenu,
        selectedRoute: selectedRoute,
        onSelected: (item) {
          Navigator.pushNamed(context, item.route);
        },
        footer: Container(
          height: 50.0,
          width: double.infinity,
          color: kMainColor.withOpacity(0.5),
          child: Center(
            child: Text('お届けくん(BtoC)', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(0.0),
              constraints: BoxConstraints(maxHeight: 750.0),
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}

class EditShopDialog extends StatefulWidget {
  final ShopProvider shopProvider;

  EditShopDialog({@required this.shopProvider});

  @override
  _EditShopDialogState createState() => _EditShopDialogState();
}

class _EditShopDialogState extends State<EditShopDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '店舗情報の編集',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopProvider.code,
              obscureText: false,
              textInputType: null,
              maxLines: 1,
              labelText: '店舗コード',
              iconData: Icons.vpn_key,
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
            Text('キャンセル期限日', style: kLabelTextStyle),
            SizedBox(height: 4.0),
            DropdownButton<int>(
              isExpanded: true,
              value: widget.shopProvider.cancelLimit,
              onChanged: (value) {
                setState(() {
                  widget.shopProvider.cancelLimit = value;
                });
              },
              items: widget.shopProvider.cancelLimitList.map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value日前'),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Divider(height: 0.0),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BorderBoxButton(
                  iconData: Icons.close,
                  labelText: '閉じる',
                  labelColor: Colors.blueGrey,
                  borderColor: Colors.blueGrey,
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: 4.0),
                BorderBoxButton(
                  iconData: Icons.exit_to_app,
                  labelText: 'ログアウト',
                  labelColor: Colors.redAccent,
                  borderColor: Colors.redAccent,
                  onTap: () {
                    widget.shopProvider.signOut();
                    widget.shopProvider.clearController();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                SizedBox(width: 4.0),
                FillBoxButton(
                  iconData: Icons.check,
                  labelText: '変更',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.shopProvider.update()) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('変更が完了しました')),
                    );
                    widget.shopProvider.clearController();
                    widget.shopProvider.reloadShopModel();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditShopRemarksDialog extends StatefulWidget {
  final ShopProvider shopProvider;

  EditShopRemarksDialog({@required this.shopProvider});

  @override
  _EditShopRemarksDialogState createState() => _EditShopRemarksDialogState();
}

class _EditShopRemarksDialogState extends State<EditShopRemarksDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '店舗説明',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopProvider.remarks,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: null,
              iconData: Icons.comment,
            ),
            SizedBox(height: 16.0),
            Divider(height: 0.0),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BorderBoxButton(
                  iconData: Icons.close,
                  labelText: '閉じる',
                  labelColor: Colors.blueGrey,
                  borderColor: Colors.blueGrey,
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: 4.0),
                FillBoxButton(
                  iconData: Icons.check,
                  labelText: '変更',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.shopProvider.updateRemarks()) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('変更が完了しました')),
                    );
                    widget.shopProvider.clearController();
                    widget.shopProvider.reloadShopModel();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditShopTermsDialog extends StatefulWidget {
  final ShopProvider shopProvider;

  EditShopTermsDialog({@required this.shopProvider});

  @override
  _EditShopTermsDialogState createState() => _EditShopTermsDialogState();
}

class _EditShopTermsDialogState extends State<EditShopTermsDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '利用規約を編集',
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: widget.shopProvider.terms,
              obscureText: false,
              textInputType: TextInputType.multiline,
              maxLines: null,
              labelText: null,
              iconData: Icons.description,
            ),
            SizedBox(height: 16.0),
            Divider(height: 0.0),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BorderBoxButton(
                  iconData: Icons.close,
                  labelText: '閉じる',
                  labelColor: Colors.blueGrey,
                  borderColor: Colors.blueGrey,
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: 4.0),
                FillBoxButton(
                  iconData: Icons.check,
                  labelText: '変更',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onTap: () async {
                    if (!await widget.shopProvider.updateTerms()) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('変更が完了しました')),
                    );
                    widget.shopProvider.clearController();
                    widget.shopProvider.reloadShopModel();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
