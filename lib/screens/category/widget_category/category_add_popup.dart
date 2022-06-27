import 'package:flutter/material.dart';
import 'package:shopky_demo_app/db_functions/catagory_db/category_db.dart';
import 'package:shopky_demo_app/models/catagory_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final nameEditingController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        backgroundColor: const Color.fromARGB(255, 237, 238, 255),
        title: const Text(
          'Add Category',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: nameEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
                hintText: 'Category Name',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                RadioButton(
                  title: 'Income',
                  type: CategoryType.income,
                ),
                RadioButton(
                  title: 'Expense',
                  type: CategoryType.expense,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: ElevatedButton(
              onPressed: () async {
                final name = nameEditingController.text;
                if (name.isEmpty) {
                  return;
                }
                final type = selectedCategoryNotifier.value;
                final category = CategoryModel(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  name: name,
                  type: type,
                );

                CategoryDB().insertCategory(category);
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff4b50c7),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Text(
                'ADD',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                value: type,
                groupValue: selectedCategoryNotifier.value,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryNotifier.value = value;
                  selectedCategoryNotifier.notifyListeners();
                },
              );
            }),
        Text(
          title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 2),
        ),
      ],
    );
  }
}
