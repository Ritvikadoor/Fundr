import 'package:flutter/material.dart';
import 'package:shopky_demo_app/db_functions/catagory_db/category_db.dart';
import 'package:shopky_demo_app/screens/category/widget_category/category_add_popup.dart';
import 'package:shopky_demo_app/screens/category/widget_category/expense_category_list.dart';
import 'package:shopky_demo_app/screens/category/widget_category/income_catagory_list.dart';
import 'package:shopky_demo_app/screens/home/home_screen.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key}) : super(key: key);

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().getCategories().then((value) {});

    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Category',
          style: TextStyle(color: Color(0xff4b50c7), fontSize: 30),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton(
          backgroundColor: const Color(0xff4b50c7),
          elevation: 0,
          onPressed: () {
            if (ScreenHome.selectedIndexNotifier.value == 1) {
              showCategoryAddPopup(context);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
            child: Column(
              children: [
                TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: const Color(0xff4b50c7),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      Tab(
                        text: 'Income',
                      ),
                      Tab(
                        text: 'Expense',
                      ),
                    ]),
                Expanded(
                  child:
                      TabBarView(controller: _tabController, children: const [
                    IncomeCatagoryList(),
                    ExpenseCatagoryList(),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
