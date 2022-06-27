import 'package:flutter/material.dart';
import 'package:shopky_demo_app/db_functions/catagory_db/category_db.dart';
import 'package:shopky_demo_app/models/catagory_model.dart';
import 'package:shopky_demo_app/screens/transactions/transaction_db/transaction_db.dart';

class ExpenseCatagoryList extends StatefulWidget {
  const ExpenseCatagoryList({Key? key}) : super(key: key);

  @override
  State<ExpenseCatagoryList> createState() => _ExpenseCatagoryListState();
}

class _ExpenseCatagoryListState extends State<ExpenseCatagoryList> {
  @override
  void initState() {
    CategoryDB.instance.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().expenseCatagoryListListener,
        builder: (BuildContext ctx, List<CategoryModel> newlist, Widget? _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: newlist.length,
                itemBuilder: (BuildContext ctx, index) {
                  final category = newlist[index];
                  return InkWell(
                    child: Container(
                      key: Key(category.id),
                      alignment: Alignment.center,
                      child: Text(category.name.toString()),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 237, 238, 255),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onTap: () {
                      _showMyDialog(context, category.id);
                    },
                  );
                }),
          );
        });
  }

  Future<void> _showMyDialog(BuildContext context, String? categoryID) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Would you like to Delete'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                CategoryDB.instance.expenseCatagoryListListener
                    .notifyListeners();
                CategoryDB.instance.deleteCategory(categoryID!);
                TransactionDb.instance.deleteTransaction(categoryID.toString());
                TransactionDb.instance.transationListNotifier.notifyListeners();
                TransactionDb.instance.refresh();
                CategoryDB.instance.refreshUI();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
