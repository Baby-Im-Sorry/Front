import 'package:bis_front/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      final now = TimeOfDay.now();
      if (picked.hour < now.hour || (picked.hour == now.hour && picked.minute < now.minute)) {
        setState(() {
          selectedTime = now;
        });
        Fluttertoast.showToast(
          msg: "Select the future time",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          fontSize: 16.0,
        );
      } else if (picked != selectedTime) {
        setState(() {
          selectedTime = picked;
        });
      }
    }
  }

  Future<void> _startBriefing(context) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/briefing'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'interval': _controller.text},
    );
    if (response.statusCode == 200) {
      print(response.statusCode);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ChatScreen())
      );
    } else {
      print('Login Failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 500,
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Time interval'),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Please Enter 1 to 100',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a number';
                          }
                          final intValue = int.tryParse(value);
                          if (intValue == null || intValue < 1 || intValue > 100) {
                            return 'Enter only 1 to 100';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("selected time: ${selectedTime.format(context)}"),
                  const SizedBox(
                    width: 110,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: const Text('select the time'),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // print(_formKey.currentState);
                    if (_formKey.currentState!.validate()) {
                      print('nice');
                      _startBriefing(context);
                    }
                  },
                  child: const Text('Start briefing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
