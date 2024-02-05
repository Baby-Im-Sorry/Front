import 'package:bis_front/briefinghistory.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryScreen extends StatefulWidget {
  final String username;
  const HistoryScreen({super.key, required this.username});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('http://10.0.2.2:8000/getAllRequest');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        "username": widget.username,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        items = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              height: 60,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100, // 배경색 설정
                borderRadius: BorderRadius.circular(30), // 모서리 둥글기 설정
              ),
              child: ListTile(
                title: Text(
                  items[index]['request_name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BriefingHistoryScreen(requestId: items[index]['request_id'], requestTitle: items[index]['request_name'])),
                  );
                },
                trailing: const Icon(Icons.arrow_forward),
              ),
            );
          },
        ),
      ),
    );
  }
}
