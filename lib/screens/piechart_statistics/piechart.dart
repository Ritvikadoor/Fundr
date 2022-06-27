import 'package:flutter/material.dart';
import 'package:shopky_demo_app/db_functions/catagory_db/category_db.dart';
import 'package:shopky_demo_app/screens/piechart_statistics/pie_chart_widget/expense_piechart_widget.dart';
import 'package:shopky_demo_app/screens/piechart_statistics/pie_chart_widget/income_pie_chart_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().getCategories().then((value) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff4b50c7)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Statistics',
          style: TextStyle(color: Color(0xff4b50c7), fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
          child: ListView(
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
                ],
              ),
              SizedBox(
                height: 1000,
                child: TabBarView(controller: _tabController, children: const [
                  IncomePieChartStatistics(),
                  ExpensePieChartStatistics(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
