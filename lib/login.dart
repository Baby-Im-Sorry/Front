import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bis_front/home.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  LoginScreen({super.key});

  Future<void> _login(context) async {
    String url = 'http://13.125.63.186:8000/login';
    // String url = 'http://127.0.0.1:8001/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': _usernameController.text
        },
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(username: _usernameController.text)),
              (Route<dynamic> route) => false,
        );
      } else {
        print('Login Failed: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Please enter your ID. If you do not have one, ID will be added',
                  labelStyle: TextStyle(
                    fontSize: 10
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () =>
                        _login(context),
                    child: const Text('Login'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}