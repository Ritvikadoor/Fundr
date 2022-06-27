import 'package:flutter/material.dart';
import 'package:shopky_demo_app/screens/piechart_statistics/pie_chart_widget/pie_chart_db.dart';
import 'package:shopky_demo_app/screens/transactions/transaction_db/transaction_db.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomePieChartStatistics extends StatefulWidget {
  const IncomePieChartStatistics({Key? key});

  @override
  IncomePieChartStatisticsState createState() =>
      IncomePieChartStatisticsState();
}

class IncomePieChartStatisticsState extends State<IncomePieChartStatistics> {
  Map<String, double> data = Map();
  final bool _loadChart = true;

  @override
  Widget build(BuildContext context) {
    List<chartData> connectedList =
        chartlogic(TransactionDb.instance.incomeChartListNotifier.value);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 0,
              ),
              child: ListView(
                children: [
                  FutureBuilder(
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return connectedList.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text(
                                  "No transaction now trying to add",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 16),
                                ),
                              ],
                            )
                          : SfCircularChart(
                              legend: Legend(
                                  isVisible: true,
                                  borderColor: Colors.black54,
                                  borderWidth: 1),
                              title: ChartTitle(
                                text: 'Income category analysis',
                                textStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              series: <CircularSeries>[
                                // Render pie chart
                                PieSeries<chartData, String>(
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                  ),
                                  dataSource: connectedList,
                                  xValueMapper: (chartData data, _) =>
                                      data.category,
                                  yValueMapper: (chartData data, _) =>
                                      data.amount,
                                )
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
