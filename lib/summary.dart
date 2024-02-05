import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SummaryScreen extends StatefulWidget {
  final String requestId;
  final String requestTitle;
  const SummaryScreen({super.key, required this.requestId, required this.requestTitle});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool isLoading = false;
  String summary = "";

  @override
  void initState() {
    super.initState();
    aiSummary();
  }

  Future<void> aiSummary() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('http://10.0.2.2:8000/aiSummary');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "request_id": widget.requestId,
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      print('yes');
      setState(() {
        summary = response.body;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'AI Summary & Solution',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('1분만 기다려 주세요^^'),
                SizedBox(height: 10),
                Text('멋있는 AI 요약이 만들어 지는 중입니다.'),
              ],
            )
          )
      : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.requestTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Card(
                  color: Colors.brown.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8.0),
                        Text(summary),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
