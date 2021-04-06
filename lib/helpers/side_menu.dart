import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:otodokekun_cource_web/screens/invoice.dart';
import 'package:otodokekun_cource_web/screens/notice.dart';
import 'package:otodokekun_cource_web/screens/order.dart';
import 'package:otodokekun_cource_web/screens/plan.dart';
import 'package:otodokekun_cource_web/screens/product.dart';
import 'package:otodokekun_cource_web/screens/report.dart';
import 'package:otodokekun_cource_web/screens/staff.dart';
import 'package:otodokekun_cource_web/screens/user.dart';

const List<MenuItem> kSideMenu = [
  MenuItem(
    title: '集計',
    route: ReportScreen.id,
    icon: Icons.view_list,
  ),
  MenuItem(
    title: '注文',
    route: OrderScreen.id,
    icon: Icons.local_shipping,
  ),
  MenuItem(
    title: '定期商品',
    route: PlanScreen.id,
    icon: Icons.view_in_ar,
  ),
  MenuItem(
    title: '個別商品',
    route: ProductScreen.id,
    icon: Icons.view_in_ar,
  ),
  MenuItem(
    title: '顧客',
    route: UserScreen.id,
    icon: Icons.supervisor_account,
  ),
  MenuItem(
    title: '担当者',
    route: StaffScreen.id,
    icon: Icons.supervisor_account,
  ),
  MenuItem(
    title: 'お知らせ(通知)',
    route: NoticeScreen.id,
    icon: Icons.notifications,
  ),
  MenuItem(
    title: '締め日',
    route: InvoiceScreen.id,
    icon: Icons.calendar_today,
  ),
];
