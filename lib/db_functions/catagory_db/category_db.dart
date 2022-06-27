import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopky_demo_app/models/catagory_model.dart';

const CATEGORY_DB_NAME = 'category_database';

abstract class CategorDbFunctions {
  Future<List<CategoryModel>> getCategories();
  void insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
  Future<void> clearCategory();
}

class CategoryDB implements CategorDbFunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCatagoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCatagoryListListener =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final allCategories = await getCategories();
    incomeCatagoryListListener.value.clear();
    expenseCatagoryListListener.value.clear();

    Future.forEach(allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCatagoryListListener.value.add(category);
      } else {
        expenseCatagoryListListener.value.add(category);
      }
    });

    incomeCatagoryListListener.notifyListeners();
    expenseCatagoryListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _categoryDB.delete(categoryID);
    refreshUI();
  }

  @override
  Future<void> clearCategory() async {
    final categoryData = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    categoryData.clear();
  }
}
