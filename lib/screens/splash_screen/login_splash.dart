import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopky_demo_app/screens/home/home_screen.dart';
import 'package:shopky_demo_app/screens/splash_screen/splash_screen_two.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late SharedPreferences preferences;

  final _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 238, 255),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(children: [
          const SizedBox(
            height: 400,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'What should we call you :)',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff4b50c7)),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Connect your name for your money manager',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 184, 183, 183)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _username,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff51425f),
                        letterSpacing: 2),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Enter your name',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 237, 238, 255)),
                      labelText: 'Name',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 237, 238, 255),
                          letterSpacing: 2),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter the Username';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: SizedBox(
                    height: 48,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_username.text.isNotEmpty) {
                          addName(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 600),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Color.fromARGB(255, 83, 83, 83),
                              content: Text(
                                'Please enter a name',
                                style: TextStyle(
                                    color: Colors.white, letterSpacing: 2),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          primary: const Color(0xff4b50c7)),
                      child: const Text(' Lets Go ',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<void> addName(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('name', _username.text);
    preferences.setBool('check', true);
    commonUserName = _username.text;

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ScreenHome()));
  }
}
