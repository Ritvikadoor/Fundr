import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopky_demo_app/db_functions/catagory_db/category_db.dart';
import 'package:shopky_demo_app/models/catagory_model.dart';
import 'package:shopky_demo_app/models/tansaction_model/transaction_model.dart';
import 'package:shopky_demo_app/screens/home/home_screen.dart';
import 'package:shopky_demo_app/screens/transactions/transaction_db/transaction_db.dart';

ValueNotifier<CategoryType> selectedTransactionNotifier =
    ValueNotifier(CategoryType.income);

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'Add_transaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;
  final _purposeTextEdittingController = TextEditingController();
  final _amountTextEdittingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: Color(0xff4b50c7)),
        ),
        iconTheme: const IconThemeData(color: Color(0xff4b50c7)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 237, 238, 255),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 30,
                      child: Center(
                        child: Text(
                          _selectedCategoryType == CategoryType.income
                              ? 'Add Income'
                              : 'Add Expense',
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _amountTextEdittingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextButton.icon(
                            onPressed: () async {
                              final _selectedDateTemp = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                lastDate: DateTime.now(),
                              );
                              if (_selectedDateTemp == null) {
                                return;
                              } else {
                                setState(() {
                                  _selectedDate = _selectedDateTemp;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                            ),
                            label: Text(
                              _selectedDate == null
                                  ? ' '
                                  : DateFormat('yMMMMd').format(_selectedDate!),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: CategoryType.income,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.income;
                                _categoryID = null;
                              });
                            },
                          ),
                          const Text('Income'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: CategoryType.expense,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.expense;
                                _categoryID = null;
                              });
                            },
                          ),
                          const Text(
                            'Expense',
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Select Category',
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                          value: _categoryID,
                          items: (_selectedCategoryType == CategoryType.income
                                  ? CategoryDB().incomeCatagoryListListener
                                  : CategoryDB().expenseCatagoryListListener)
                              .value
                              .map(
                            (e) {
                              return DropdownMenuItem(
                                value: e.id,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(e.name),
                                ),
                                onTap: () {
                                  _selectedCategoryModel = e;
                                },
                              );
                            },
                          ).toList(),
                          onChanged: (selectedValue) {
                            setState(() {
                              _categoryID = selectedValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _purposeTextEdittingController,
                      decoration: InputDecoration(
                          hintText: 'Notes',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        addTransaction();

                        TransactionDb.instance.refresh();
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    final purposeText = _purposeTextEdittingController.text;
    final amountText = _amountTextEdittingController.text;
    if (purposeText.isEmpty) {
      return;
    }
    if (amountText.isEmpty) {
      return;
    }
    if (_categoryID == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }

    final parsedamount = double.tryParse(amountText);
    if (parsedamount == null) {
      return;
    }

    if (_selectedCategoryModel == null) {
      return;
    }
    final model = TransactionModel(
      purpose: purposeText,
      amount: parsedamount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
      id: id,
    );

    TransactionDb.instance.addTransaction(model);
    TransactionDb.instance.refresh();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return const ScreenHome();
    }));
  }
}
