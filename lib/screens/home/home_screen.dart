import 'package:flutter/material.dart';
import 'package:shopky_demo_app/db_functions/catagory_db/category_db.dart';
import 'package:shopky_demo_app/screens/category/screen_catagory.dart';
import 'package:shopky_demo_app/screens/home/widgets_home/bottom_navigation.dart';
import 'package:shopky_demo_app/screens/piechart_statistics/piechart.dart';
import 'package:shopky_demo_app/screens/settings/screen_settings.dart';
import 'package:shopky_demo_app/screens/transactions/edit_transaction/screen_transaction.dart';
import 'package:shopky_demo_app/screens/transactions/transaction_db/transaction_db.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    TransactionDb.instance.refresh();
    CategoryDB.instance.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: ScreenHome.selectedIndexNotifier,
            builder: (BuildContext context, int updatedIndex, _) {
              return _pages[updatedIndex];
            }),
      ),
    );
  }
}
