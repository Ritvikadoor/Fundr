import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopky_demo_app/models/catagory_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final CategoryType type;
  @HiveField(4)
  final CategoryModel category;
  @HiveField(5)
  final String? purpose;

  TransactionModel({
    required this.id,
    required this.purpose,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });
}
