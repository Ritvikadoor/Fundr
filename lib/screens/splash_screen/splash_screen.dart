import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopky_demo_app/screens/home/home_screen.dart';
import 'package:shopky_demo_app/screens/splash_screen/splash_screen_two.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () => callHome());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 237, 238, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/logo_fundr.png',
              height: 150,
            ),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText('Your Own Financial Journal',
                    textStyle: const TextStyle(
                      color: Color(0xff4b50c7),
                      fontSize: 20,
                    )),
                TyperAnimatedText(
                  'Fundr',
                  textStyle: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4b50c7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  callHome() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getBool('check') ?? false;
    if (data == false) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ScreenSplashTwo()));
    } else {
      commonUserName = pref.getString('name') ?? 'User';
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ScreenHome()));
    }
  }
}
