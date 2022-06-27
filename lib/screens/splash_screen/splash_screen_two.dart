import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopky_demo_app/screens/splash_screen/login_splash.dart';

class ScreenSplashTwo extends StatefulWidget {
  const ScreenSplashTwo({Key? key}) : super(key: key);

  @override
  State<ScreenSplashTwo> createState() => _ScreenSplashTwoState();
}

String commonUserName = '';

class _ScreenSplashTwoState extends State<ScreenSplashTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          Lottie.asset(
            "lib/assets/money_getstarted.json",
            height: 500,
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: SizedBox(
                height: 40,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (ctx) {
                      return const LoginScreen();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff4b50c7),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      )),
      backgroundColor: const Color.fromARGB(255, 237, 238, 255),
    );
  }
}
