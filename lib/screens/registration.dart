import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/user.dart';
import 'package:otodokekun_cource_web/widgets/border_round_button.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/link_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatelessWidget {
  static const String id = 'registration';

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    return Scaffold(
      backgroundColor: kMainColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: shopProvider.status == Status.Authenticating
              ? Center(
                  child: LoadingWidget(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.0),
                    Text(
                      'お届けくん',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'BtoCサービス',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      height: 480.0,
                      width: 325.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('店舗専用新規登録'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomTextField(
                                  controller: shopProvider.name,
                                  obscureText: false,
                                  textInputType: TextInputType.name,
                                  maxLines: 1,
                                  labelText: '店舗名',
                                  iconData: Icons.store_outlined,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomTextField(
                                  controller: shopProvider.email,
                                  obscureText: false,
                                  textInputType: TextInputType.emailAddress,
                                  maxLines: 1,
                                  labelText: 'メールアドレス',
                                  iconData: Icons.email_outlined,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomTextField(
                                  controller: shopProvider.password,
                                  obscureText: true,
                                  textInputType: TextInputType.visiblePassword,
                                  maxLines: 1,
                                  labelText: 'パスワード',
                                  iconData: Icons.lock_outline,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomTextField(
                                  controller: shopProvider.cPassword,
                                  obscureText: true,
                                  textInputType: TextInputType.visiblePassword,
                                  maxLines: 1,
                                  labelText: 'パスワードの再入力',
                                  iconData: Icons.lock_outline,
                                ),
                              ),
                              SizedBox(height: 24.0),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: BorderRoundButton(
                                  labelText: '新規登録',
                                  labelColor: Colors.blueAccent,
                                  borderColor: Colors.blueAccent,
                                  onTap: () async {
                                    if (!await shopProvider.signUp()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('新規登録できませんでした')),
                                      );
                                      return;
                                    }
                                    shopProvider.clearController();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserScreen(),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          LinkButton(
                            labelText: 'ログインはコチラ',
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
