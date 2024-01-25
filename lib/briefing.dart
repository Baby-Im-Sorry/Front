import 'dart:convert';

import 'package:bis_front/home.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

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
  String request_id = "";

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

  Future<void> _endBriefing(BuildContext context, username) async {
    String url = 'http://10.0.2.2:8000/endBriefing';
    print('plz');
    _channel?.sink.close();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('yes');
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => HomeScreen(username: widget.username)),
        //       (Route<dynamic> route) => false,
        // );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // void _connectToWebSocket() {
  //   _getCurrentBriefing().then((value) {
  //     // 웹소켓 채널을 변수에 저장
  //     _channel = WebSocketChannel.connect(Uri.parse(widget.websocketUrl));
  //     // 필요한 추가 로직 (예: 상태 업데이트, 메시지 수신 처리 등)
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse(widget.websocketUrl));
    // _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8000/ws'));
  }

  // void _sendMessage(WebSocketChannel? channel) {
  //   // WebSocketChannel channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8000/ws'));
  //   if (channel != null) {
  //     // print(channel);
  //     channel.sink.close();
  //     print('pressed');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Briefing'),
        actions: [
          TextButton(
            onPressed: () {
              _endBriefing(context, widget.username);
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
        stream: _channel?.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.hasData) {
            messages.add(snapshot.data);
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
    );
  }

  // void sendMessage() {
  //   if (my_controller.text.isNotEmpty) {
  //     channel.sink.add(my_controller.text);
  //     my_controller.text = '';
  //   }
  // }

  // close the connection
  @override
  void dispose() {
    _channel?.sink.close();
    // myController.dispose();
    super.dispose();
  }
}