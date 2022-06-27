import 'package:shopky_demo_app/models/tansaction_model/transaction_model.dart';

class chartData {
  String? category;
  double? amount;
  chartData({required this.category, required this.amount});
}

List<chartData> chartlogic(List<TransactionModel> model) {
  double value;
  String categoryname;
  List visited = [];
  List<chartData> thedata = [];
  for (var i = 0; i < model.length; i++) {
    visited.add(0);
  }
  for (var i = 0; i < model.length; i++) {
    value = model[i].amount;
    categoryname = model[i].category.name;

    for (var j = i + 1; j < model.length; j++) {
      if (model[i].category.name == model[j].category.name) {
        value += model[j].amount;
        visited[j] = -1;
      }
    }

    if (visited[i] != -1) {
      thedata.add(chartData(category: categoryname, amount: value));
    }
  }

  return thedata;
}
