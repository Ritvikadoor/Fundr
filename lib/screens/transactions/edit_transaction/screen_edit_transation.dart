import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopky_demo_app/db_functions/catagory_db/category_db.dart';
import 'package:shopky_demo_app/models/catagory_model.dart';
import 'package:shopky_demo_app/models/tansaction_model/transaction_model.dart';
import 'package:shopky_demo_app/screens/transactions/transaction_db/transaction_db.dart';

ValueNotifier<CategoryType> selectedTransactionNotifier =
    ValueNotifier(CategoryType.income);

class EditScreenTransaction extends StatefulWidget {
  static const routeName = 'add_transaction';

  TransactionModel valued;
  EditScreenTransaction({Key? key, required this.valued}) : super(key: key);
  @override
  State<EditScreenTransaction> createState() => _EditScreenTransactionState();
}

class _EditScreenTransactionState extends State<EditScreenTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;
  final _purposeTextEdittingController = TextEditingController();
  final _amountTextEdittingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    _purposeTextEdittingController.text = widget.valued.purpose!;
    _amountTextEdittingController.text = widget.valued.amount.toString();
    _selectedCategoryModel = widget.valued.category;
    _selectedDate = widget.valued.date;

    CategoryDB.instance.refreshUI();

    TransactionDb.instance.refresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xff4b50c7)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Edit Transaction',
          style: TextStyle(fontSize: 20, color: Color(0xff4b50c7)),
        ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
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

                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _amountTextEdittingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),

                //calender

                Center(
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: TextButton.icon(
                      onPressed: () async {
                        final selectedDateTemp = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDateTemp == null) {
                          return;
                        } else {
                          // print(selectedDateTemp.toString());
                          setState(() {
                            _selectedDate = selectedDateTemp;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      label: Text(_selectedDate == null
                          ? DateFormat('yMMMMd').format(widget.valued.date)
                          : DateFormat('yMMMMd').format(_selectedDate!)),
                    ),
                  ),
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
                        const Text('Expense'),
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
                        hint: _selectedCategoryType == widget.valued.type
                            ? Text(widget.valued.category.name)
                            : const Text('Selected Category'),
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
                          // print(selectedValue);
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
                  child: TextFormField(
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
                    },
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final purposeText = _purposeTextEdittingController.text;
    final amountText = _amountTextEdittingController.text;
    final parsedamount = double.tryParse(amountText);

    final model = TransactionModel(
      id: widget.valued.id,
      purpose: purposeText,
      amount: parsedamount!,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );

    await TransactionDb.instance.updateTransaction(model, widget.valued.id!);
    TransactionDb.instance.refresh();
    Navigator.pop(context);
  }
}
