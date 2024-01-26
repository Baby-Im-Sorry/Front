import 'dart:async';
import 'dart:convert';
import 'package:bis_front/briefing.dart';
import 'package:bis_front/home.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class ActiveChatScreen extends StatefulWidget {
  final String websocketUrl;
  final String username;
  const ActiveChatScreen({super.key, required this.websocketUrl, required this.username});

  @override
  State<ActiveChatScreen> createState() => _ActiveChatScreenState();
}

class _ActiveChatScreenState extends State<ActiveChatScreen> {
  // WebSocketChannel? _channel;
  List<String> messages = [];
  WebSocketManager? webSocketManager;

  // Future<void> _getCurrentBriefing() async {
  //   String url = 'http://127.0.0.1:8000/getCurrentBriefing?username=${widget.username}';
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     // print(response.body);
  //     var data = jsonDecode(response.body);
  //     // print(data);
  //     request_id = data['request_id'];
  //     var content = data['content'] as List<dynamic>;
  //     var stringList = content.map((e) => e as String).toList();
  //     // print(content);
  //     if (stringList != []) {
  //       setState(() {
  //         messages.addAll(stringList);
  //       });
  //     }
  //     // print(messages);
  //   } else {
  //     print('error');
  //   }
  // }


  // void _connectToWebSocket() {
  //   _getCurrentBriefing().then((value) {
  //     // 웹소켓 채널을 변수에 저장
  //     _channel = WebSocketChannel.connect(Uri.parse(widget.websocketUrl));
  //     // 필요한 추가 로직 (예: 상태 업데이트, 메시지 수신 처리 등)
  //   });
  // }

  Future<void> _endBriefing(BuildContext context, username) async {
    String url = 'http://10.0.2.2:8000/endBriefing';
    print('plz');
    // _channel?.sink.close();
    webSocketManager?.dispose();
    try {
      await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username
        },
      );
      print('yes');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    webSocketManager = WebSocketManager(widget.websocketUrl);
    connectWebSocket();
    // _channel = WebSocketChannel.connect(Uri.parse(widget.websocketUrl));
  }

  void connectWebSocket() {
    webSocketManager?.streamController.stream.listen((data) {
      // print(data);
      var decodedData = jsonDecode(data);
      // print(decodedData);
      print(decodedData['briefing_data']);
      // setState(() {
        // messages = decodedData['briefing_data'].map((item) => item.toString()).toList();
      // messages.addAll(decodedData['briefing_data']);
      // });
    }, onDone: () {
      print("WebSocket connection closed.");
    }, onError: (error) {
      print("WebSocket error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        // _channel?.sink.close();
        webSocketManager?.dispose();
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Briefing'),
          actions: [
            TextButton(
              child: const Text('Stop'),
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(username: widget.username)),
                      (Route<dynamic> route) => false,
                );
                await _endBriefing(context, widget.username);
              },
            ),
            TextButton(
              child: const Text('fuck'),
              onPressed: () {
                print(widget.username);
                print(widget.websocketUrl);
              },
            ),
          ],
        ),
        body: StreamBuilder(
          stream: webSocketManager?.streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.hasData) {
              if (snapshot.data!.startsWith('{"')) {
                Map<String, dynamic> decoded = jsonDecode(snapshot.data ?? 'Oops! Temporary Network Error');
                List<dynamic> briefingData = decoded['briefing_data'];
                messages.addAll(briefingData.map((item) => item.toString()).toList());
              } else {
                messages.add(snapshot.data ?? 'Oops! Temporary Network Error');
                // messages.add('No data');
              }
            }
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _channel?.sink.close();
    webSocketManager?.dispose();
    super.dispose();
  }
}