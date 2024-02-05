import 'dart:async';
import 'package:bis_front/activebriefing.dart';
import 'package:bis_front/briefing.dart';
import 'package:bis_front/gptcustom.dart';
import 'package:bis_front/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


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
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(username: widget.username)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen(username: widget.username)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GptCustomScreen(username: widget.username)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String activeWebsocketUrl = 'ws://10.0.2.2:8000/reloadBriefing?username=${widget.username}';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Custom',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 500,
          child: Column(
            children: [
              const SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Row(
                  children: [
                    const Text(
                      'Time interval',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Please Enter 1 to 100',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
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
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "end time: ${selectedTime.format(context)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreenAccent),
                    ),
                    child: const Text(
                      'set the end time',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedTime == TimeOfDay.now()) {
                    Fluttertoast.showToast(
                      msg: "please set the end time",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      fontSize: 16.0,
                    );
                  } else if (_formKey.currentState!.validate()) {
                    _startBriefing(context);
                  }
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(const Size(350, 40)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan.shade100),
                ),
                child: const Text(
                  'Start briefing',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
