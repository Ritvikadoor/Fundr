import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopky_demo_app/db_functions/catagory_db/category_db.dart';
import 'package:shopky_demo_app/models/catagory_model.dart';
import 'package:shopky_demo_app/models/tansaction_model/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction_db';

abstract class TransactionDbFunction {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String index);
  Future<void> updateTransaction(TransactionModel obj, String id);
  Future<void> clearData();
  Future<void> clearCategory();
}

class TransactionDb implements TransactionDbFunction {
  TransactionDb._internal();
  static TransactionDb instance = TransactionDb._internal();

  factory TransactionDb() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> todayNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> yesterdayNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> weeklyNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> transationListNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> incomeChartListNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> expenseChartListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> todayListNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> yesterdayListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> weeklyListNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthlyListNotifier = ValueNotifier([]);

  String todayDate = DateFormat.yMd().format(DateTime.now());
  String yesterdayDate =
      DateFormat.yMd().format(DateTime.now().subtract(const Duration(days: 1)));
  String weeklyDate = DateFormat('yyyyMMdd').format(DateTime.now());

  String monthlyDate = DateFormat('yyyyMMdd').format(DateTime.now());
  int monthyDateint = int.parse(DateFormat('MM').format(DateTime.now()));

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);

    await _db.put(obj.id, obj);
    refresh();
  }

  ValueNotifier<double> balacneNotifier = ValueNotifier(0);
  ValueNotifier<double> incomeNotifier = ValueNotifier(0);
  ValueNotifier<double> expenseNotifier = ValueNotifier(0);

  Future<void> refresh() async {
    final preferences = SharedPreferences.getInstance();

    var _list = await getAllTransactions();
    _list = _list.reversed.toList();
    _list.sort((first, second) => second.date.compareTo(first.date));

    transationListNotifier.value.clear();
    transationListNotifier.value.addAll(_list);
    incomeChartListNotifier.value.clear();
    expenseChartListNotifier.value.clear();
    balacneNotifier.value = 0;
    incomeNotifier.value = 0;
    expenseNotifier.value = 0;

    for (var data in _list) {
      if (data.type == CategoryType.income) {
        incomeChartListNotifier.value.add(data);
      } else if (data.type == CategoryType.expense) {
        expenseChartListNotifier.value.add(data);
      }
    }

    await Future.forEach(_list, (TransactionModel category) {
      balacneNotifier.value = balacneNotifier.value + category.amount;

      if (category.type == CategoryType.income) {
        incomeNotifier.value = incomeNotifier.value + category.amount;
      } else if (category.type == CategoryType.expense) {
        expenseNotifier.value = expenseNotifier.value + category.amount;
      }
    });
    balacneNotifier.value = incomeNotifier.value - expenseNotifier.value;
    transationListNotifier.notifyListeners();
    incomeChartListNotifier.notifyListeners();
    expenseChartListNotifier.notifyListeners();
    balacneNotifier.notifyListeners();
    incomeNotifier.notifyListeners();
    expenseNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);

    return _db.values.toList();
  }

  @override
  deleteTransaction(String index) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    _db.delete(index);
  }

  @override
  Future<void> updateTransaction(TransactionModel obj, String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    _db.put(id, obj);
    refresh();
  }

  @override
  Future<void> clearData() async {
    final clearDataDb =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await clearDataDb.clear();
  }

  @override
  Future<void> clearCategory() async {
    final clearDataCategory = await Hive.openBox<CategoryDB>(CATEGORY_DB_NAME);
    await clearDataCategory.clear();
  }

  Future<void> filtration(List<TransactionModel> selectedlist) async {
    var selectedlist = await getAllTransactions();

    int weekdateint = int.parse(weeklyDate);
    todayListNotifier.value.clear();
    yesterdayListNotifier.value.clear();
    weeklyListNotifier.value.clear();
    monthlyListNotifier.value.clear();

    await Future.forEach(selectedlist, (TransactionModel singleModel) {
      String eachModelDate = DateFormat.yMd().format(singleModel.date);
      int eachmodeldateint =
          int.parse(DateFormat('yyyyMMdd').format(singleModel.date));

      if (todayDate == eachModelDate) {
        todayListNotifier.value.add(singleModel);
      }
      if (yesterdayDate == eachModelDate) {
        yesterdayListNotifier.value.add(singleModel);
      }
      if (eachmodeldateint >= (weekdateint - 7)) {
        weeklyListNotifier.value.add(singleModel);
      }
    });
  }
}
