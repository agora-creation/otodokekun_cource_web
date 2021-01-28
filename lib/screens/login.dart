import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/providers/shop.dart';
import 'package:otodokekun_cource_web/screens/registration.dart';
import 'package:otodokekun_cource_web/screens/user.dart';
import 'package:otodokekun_cource_web/widgets/custom_text_field.dart';
import 'package:otodokekun_cource_web/widgets/fill_round_button.dart';
import 'package:otodokekun_cource_web/widgets/link_button.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
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
                      '期間配達サービス',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      height: 380.0,
                      width: 325.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('店舗様ログインページ'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomTextField(
                                  controller: shopProvider.email,
                                  obscureText: false,
                                  labelText: 'メールアドレス',
                                  iconData: Icons.email,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomTextField(
                                  controller: shopProvider.password,
                                  obscureText: true,
                                  labelText: 'パスワード',
                                  iconData: Icons.lock,
                                ),
                              ),
                              SizedBox(height: 24.0),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: FillRoundButton(
                                  labelText: 'ログイン',
                                  labelColor: Colors.white,
                                  backgroundColor: Colors.blueAccent,
                                  onTap: () async {
                                    if (!await shopProvider.signIn()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('ログインできませんでした')),
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
                            labelText: '店舗様新規登録ページへ',
                            onTap: () {
                              shopProvider.clearController();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistrationScreen(),
                                ),
                              );
                            },
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
