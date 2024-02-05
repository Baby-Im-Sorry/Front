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
    // _channel = WebSocketChannel.connect(Uri.parse(widget.websocketUrl));
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
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(username: widget.username)),
                      (Route<dynamic> route) => false,
                );
                await _endBriefing(context, widget.username);
              },
              child: const Text('Stop'),
            ),
            TextButton(
              onPressed: () {
                print(widget.username);
                print(widget.websocketUrl);
              },
              child: const Text('fuck'),)
          ],
        ),
        body: StreamBuilder(
          // stream: _channel?.stream,
          stream: webSocketManager?.streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.hasData) {
              messages.add(snapshot.data ?? 'No data');
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