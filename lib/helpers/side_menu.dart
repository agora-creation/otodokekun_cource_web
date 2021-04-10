import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:otodokekun_cource_web/screens/invoice.dart';
import 'package:otodokekun_cource_web/screens/notice.dart';
import 'package:otodokekun_cource_web/screens/order.dart';
import 'package:otodokekun_cource_web/screens/product.dart';
import 'package:otodokekun_cource_web/screens/product_regular.dart';
import 'package:otodokekun_cource_web/screens/report_order.dart';
import 'package:otodokekun_cource_web/screens/report_product.dart';
import 'package:otodokekun_cource_web/screens/report_user.dart';
import 'package:otodokekun_cource_web/screens/shop.dart';
import 'package:otodokekun_cource_web/screens/shop_terms.dart';
import 'package:otodokekun_cource_web/screens/staff.dart';
import 'package:otodokekun_cource_web/screens/user.dart';

const List<MenuItem> kSideMenu = [
  MenuItem(
    title: '集計',
    icon: Icons.view_list,
    children: [
      MenuItem(
        title: '注文毎',
        route: ReportOrderScreen.id,
      ),
      MenuItem(
        title: '商品毎',
        route: ReportProductScreen.id,
      ),
      MenuItem(
        title: '顧客毎',
        route: ReportUserScreen.id,
      ),
    ],
  ),
  MenuItem(
    title: '注文',
    route: OrderScreen.id,
    icon: Icons.local_shipping,
  ),
  MenuItem(
    title: '商品',
    icon: Icons.view_in_ar,
    children: [
      MenuItem(
        title: '商品',
        route: ProductScreen.id,
      ),
      MenuItem(
        title: '定期便',
        route: ProductRegularScreen.id,
      ),
    ],
  ),
  MenuItem(
    title: '顧客',
    route: UserScreen.id,
    icon: Icons.person,
  ),
  MenuItem(
    title: '担当者',
    route: StaffScreen.id,
    icon: Icons.supervisor_account_outlined,
  ),
  MenuItem(
    title: 'お知らせ(通知)',
    route: NoticeScreen.id,
    icon: Icons.notifications,
  ),
  MenuItem(
    title: '締日(期間)',
    route: InvoiceScreen.id,
    icon: Icons.date_range,
  ),
  MenuItem(
    title: '店舗',
    icon: Icons.store,
    children: [
      MenuItem(
        title: '店舗情報',
        route: ShopScreen.id,
      ),
      MenuItem(
        title: '利用規約',
        route: ShopTermsScreen.id,
      ),
    ],
  ),
];
