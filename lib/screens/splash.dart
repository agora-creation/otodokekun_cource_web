import 'package:flutter/material.dart';
import 'package:otodokekun_cource_web/helpers/style.dart';
import 'package:otodokekun_cource_web/widgets/loading.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
