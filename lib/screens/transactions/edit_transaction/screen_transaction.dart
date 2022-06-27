import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shopky_demo_app/db_functions/catagory_db/category_db.dart';
import 'package:shopky_demo_app/models/catagory_model.dart';
import 'package:shopky_demo_app/models/tansaction_model/transaction_model.dart';
import 'package:shopky_demo_app/screens/home/home_screen.dart';
import 'package:shopky_demo_app/screens/home/widgets_home/home_screen_card_widget.dart';
import 'package:shopky_demo_app/screens/transactions/add_transaction.dart/screen_add_transaction.dart';
import 'package:shopky_demo_app/screens/transactions/edit_transaction/screen_edit_transation.dart';
import 'package:shopky_demo_app/screens/transactions/screen_seemore_transaction.dart';
import 'package:shopky_demo_app/screens/transactions/transaction_db/transaction_db.dart';

class ScreenTransaction extends StatefulWidget {
  const ScreenTransaction({Key? key}) : super(key: key);
  @override
  State<ScreenTransaction> createState() => _ScreenTransactionState();
}

class _ScreenTransactionState extends State<ScreenTransaction> {
  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    CategoryDB.instance.refreshUI();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff4b50c7),
        elevation: 0,
        onPressed: () {
          if (ScreenHome.selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const ProfitCard(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeeMoreTransaction(),
                      ),
                    );
                  },
                  child: const Text('See More:'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 237, 238, 255),
                ),
                child: ValueListenableBuilder(
                  valueListenable:
                      TransactionDb.instance.transationListNotifier,
                  builder: (BuildContext ctx, List<TransactionModel> newList,
                      Widget? _) {
                    return ListView.separated(
                      itemBuilder: ((context, index) {
                        final value = newList[index];

                        return Slidable(
                          //key: Key(value.id!),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (ctx) {
                                  _showMyDialog(context, id: value.id!);
                                },
                              ),
                              SlidableAction(
                                onPressed: (ctx) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditScreenTransaction(
                                          valued: value,
                                        ),
                                      ));
                                },
                                icon: const IconData(0xf00d,
                                    fontFamily: 'MaterialIcons'),
                                label: 'Edit',
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Card(
                                elevation: 0,
                                child: ListTile(
                                  tileColor: Colors.white,
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: value.type == CategoryType.income
                                        ? const Icon(
                                            Icons.arrow_circle_down_sharp,
                                            color: Colors.green,
                                            size: 40,
                                          )
                                        : const Icon(
                                            Icons.arrow_circle_up_sharp,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                  ),
                                  title: Text(value.category.name),
                                  subtitle: Text(
                                    parseDate(value.date),
                                  ),
                                  trailing: Text(
                                    '\u{20B9} ${value.amount}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      separatorBuilder: (ctx, index) {
                        return const SizedBox(
                          height: 2,
                        );
                      },
                      itemCount: newList.length < 6 ? newList.length : 6,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final splitDate = _date.split(' ');
    return '${splitDate.last} ${splitDate.first}';
  }

  Future<void> _showMyDialog<TransactionModel>(BuildContext context,
      {required String id}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Do you really want to delete transaction '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                TransactionDb.instance.deleteTransaction(id);
                TransactionDb.instance.refresh();
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
