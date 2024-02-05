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
  List<String> messages = [];
  WebSocketManager? webSocketManager;

  Future<void> _endBriefing(BuildContext context, username) async {
    String url = 'http://10.0.2.2:8000/endBriefing';
    print('plz');
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
  }

  void connectWebSocket() {
    webSocketManager?.streamController.stream.listen((data) {
      var decodedData = jsonDecode(data);
      print(decodedData['briefing_data']);
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
    webSocketManager?.dispose();
    super.dispose();
  }
}