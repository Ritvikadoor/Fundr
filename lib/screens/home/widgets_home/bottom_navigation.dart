import 'package:flutter/material.dart';
import 'package:shopky_demo_app/screens/home/home_screen.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
                selectedItemColor: Colors.white,
                unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
                elevation: 0,
                currentIndex: updatedIndex,
                onTap: (newIndex) {
                  ScreenHome.selectedIndexNotifier.value = newIndex;
                },
                items: const [
                  BottomNavigationBarItem(
                    backgroundColor: Color(0xff4b50c7),
                    icon: Icon(Icons.home),
                    label: 'Transactions',
                  ),
                  BottomNavigationBarItem(
                      backgroundColor: Color(0xff4b50c7),
                      icon: Icon(Icons.category),
                      label: 'Category'),
                  BottomNavigationBarItem(
                      backgroundColor: Color(0xff4b50c7),
                      icon: Icon(Icons.pie_chart),
                      label: 'Statistics'),
                  BottomNavigationBarItem(
                      backgroundColor: Color(0xff4b50c7),
                      icon: Icon(Icons.settings),
                      label: 'Settings'),
                ]),
          ),
        );
      },
    );
  }
}
