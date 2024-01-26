import 'dart:async';

import 'package:bis_front/activebriefing.dart';
import 'package:bis_front/briefing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

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
      print(now);
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

  // Future<void> _startBriefing(context) async {
  //   // String url = 'http://13.125.63.186:8000/startBriefing';
  //   String url = 'http://127.0.0.1:8000/startBriefing';
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //     },
  //     body: {
  //       'username' : widget.username,
  //       'interval' : _controller.text,
  //       'endtime' : selectedTime.format(context),
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     // print(response.statusCode);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => const ChatScreen())
  //     );
  //   } else {
  //     print('startBreifing Failed: ${response.body}');
  //   }
  // }

  void _startBriefing(context) {
    final interval = _controller.text;
    final endtime = selectedTime.format(context);
    final websocketUrl = 'ws://10.0.2.2:8000/ws?username=${widget.username}&interval=$interval&endtime=$endtime';
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(websocketUrl: websocketUrl, username: widget.username))
    );
  }

  @override
  Widget build(BuildContext context) {
    String activeWebsocketUrl = 'ws://10.0.2.2:8000/reloadBriefing?username=${widget.username}';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        actions: [
          TextButton(
            child: const Text('Briefing'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActiveChatScreen(websocketUrl: activeWebsocketUrl, username: widget.username))
              );
            },
          ),
        ],
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
                  // Text("end time: ${selectedTime.format(context).toString().split(":")[0]}:00"),
                  Text("end time: ${selectedTime.format(context)}"),
                  const SizedBox(
                    width: 120,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: const Text('set the end time'),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
                child: Text('Now only time is available. Minutes are not available.'),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // print(_formKey.currentState);
                    if (selectedTime == TimeOfDay.now()) {
                      Fluttertoast.showToast(
                        msg: "please set the end time",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3,
                        fontSize: 16.0,
                      );
                    } else if (_formKey.currentState!.validate()) {
                      // print('nice');
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
