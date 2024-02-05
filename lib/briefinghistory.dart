import 'package:bis_front/summary.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BriefingHistoryScreen extends StatefulWidget {
  final String requestId;
  final String requestTitle;
  const BriefingHistoryScreen({super.key, required this.requestId, required this.requestTitle});

  @override
  State<BriefingHistoryScreen> createState() => _BriefingHistoryScreenState();
}

class _BriefingHistoryScreenState extends State<BriefingHistoryScreen> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print(widget.requestId);
    var url = Uri.parse('http://10.0.2.2:8000/getBriefing');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "request_id": widget.requestId,
      },
    );
    print('yes');
    print(response.body);
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
          'Briefing History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    widget.requestTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 10, left: 30, right: 30),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.brown.shade50,
              ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      items[index],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, bottom: 10),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SummaryScreen(requestId: widget.requestId, requestTitle: widget.requestTitle)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
            child: const Text(
              'AI Summary',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
