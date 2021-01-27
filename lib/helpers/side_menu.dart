import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:otodokekun_cource_web/screens/course.dart';
import 'package:otodokekun_cource_web/screens/notice.dart';
import 'package:otodokekun_cource_web/screens/order.dart';
import 'package:otodokekun_cource_web/screens/product.dart';
import 'package:otodokekun_cource_web/screens/user.dart';

const List<MenuItem> kSideMenu = [
  MenuItem(
    title: '注文',
    route: OrderScreen.id,
    icon: Icons.local_shipping,
  ),
  MenuItem(
    title: '商品',
    route: ProductScreen.id,
    icon: Icons.view_in_ar,
  ),
  MenuItem(
    title: 'コース(セット)商品',
    route: CourseScreen.id,
    icon: Icons.view_in_ar,
  ),
  MenuItem(
    title: '顧客',
    route: UserScreen.id,
    icon: Icons.supervisor_account,
  ),
  MenuItem(
    title: 'お知らせ',
    route: NoticeScreen.id,
    icon: Icons.notifications,
  ),
];