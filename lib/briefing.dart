import 'dart:async';
import 'dart:convert';

import 'package:bis_front/home.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class WebSocketManager {
  final WebSocketChannel channel;
  final StreamController<String> streamController;

  WebSocketManager(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url)),
        streamController = StreamController<String>.broadcast() {
    channel.stream.listen(
          (data) {
        streamController.add(data);
      },
      onDone: () {
        streamController.close();
      },
      onError: (error) {
        streamController.addError(error);
      },
    );
  }

  void dispose() {
    // WebSocket 채널 닫기
    channel.sink.close();
    // StreamController 닫기
    streamController.close();
  }
}

class ChatScreen extends StatefulWidget {
  final String websocketUrl;
  final String username;
  const ChatScreen({super.key, required this.websocketUrl, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  WebSocketChannel? _channel;
  List<String> messages = [];
  WebSocketManager? webSocketManager;

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
          centerTitle: true,
          title: const Text(
            'Briefing',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextButton(
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(username: widget.username)),
                        (Route<dynamic> route) => false,
                  );
                  await _endBriefing(context, widget.username);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent, // 버튼 배경색
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0), // 버튼 내부 패딩
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)), // 버튼 모서리 둥글기
                  ),
                ),
                child: const Text(
                  'Stop',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
        body: StreamBuilder(
          stream: webSocketManager?.streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.hasData) {
              messages.add(snapshot.data ?? 'No data');
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 80, left: 30, right: 30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.brown.shade50,
                  ),
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          messages[index],
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