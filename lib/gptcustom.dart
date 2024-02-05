import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GptCustomScreen extends StatefulWidget {
  final String username;
  const GptCustomScreen({super.key, required this.username});

  @override
  State<GptCustomScreen> createState() => _GptCustomScreenState();
}

class _GptCustomScreenState extends State<GptCustomScreen> {
  late List<dynamic> _instructionsList = [];
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();

  Future<void> updateCustom(instructionList) async {
    print(jsonEncode((instructionList)));
    var url = Uri.parse('http://10.0.2.2:8000/updateCustom');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "username": widget.username,
        "custom_list": jsonEncode(instructionList),
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      print('yes');
    }
  }

  Future<void> getCustom() async {
    var url = Uri.parse('http://10.0.2.2:8000/getCustom');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "username": widget.username,
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      print('yes');
      var data = jsonDecode(response.body);
      _instructionsList = data;
      // print(_instructionsList);
    }
  }

  @override
  void initState() {
    super.initState();
    getCustom().then((_) {
      setState(() {
        if (_instructionsList.isNotEmpty) {
          _controller1.text = _instructionsList[0];
          _controller2.text = _instructionsList[1];
          _controller3.text = _instructionsList[2];
        }
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  Widget buildTextField(TextEditingController controller, FocusNode focusNode, String hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'GPT Customization',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildTextField(_controller1, _focusNode1, 'Enter GPT instruction 1'),
              buildTextField(_controller2, _focusNode2, 'Enter GPT instruction 2'),
              buildTextField(_controller3, _focusNode3, 'Enter GPT instruction 3'),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 40, left: 10),
        child: ElevatedButton(
          onPressed: () {
            _instructionsList = [_controller1.text, _controller2.text, _controller3.text];
            // print(_instructionsList);
            updateCustom(_instructionsList);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan.shade100,
            minimumSize: const Size(double.infinity, 50), // 버튼의 최소 크기 설정
          ),
          child: const Text(
            'Save',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}