import 'dart:async';
import 'dart:convert';
import 'package:web_socket_client/web_socket_client.dart';

class ChatWebService {
  static final _instance = ChatWebService._internal();
  WebSocket? _socket;

  factory ChatWebService() => _instance;
  ChatWebService._internal();

  final _searchResultController = StreamController<Map<String, dynamic>>();
  final _contentController = StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get searchResultStream =>
      _searchResultController.stream;
  Stream<Map<String, dynamic>> get contentStream => _contentController.stream;

  void connect() {
    const String serverIP = "localhost"; // Replace with your local server IP
    const String wsUrl = "ws://$serverIP:8000/ws/chat";

    try {
      _socket = WebSocket(Uri.parse(wsUrl));

      _socket!.messages.listen((message) {
        final data = json.decode(message);
        if (data['type'] == 'search_result') {
          _searchResultController.add(data);
        } else if (data['type'] == 'content') {
          _contentController.add(data);
        }
      });
    } catch (e) {
      print("WebSocket Error: $e");
    }
  }

  void chat(String query) {
    if (_socket != null) {
      _socket!.send(json.encode({'query': query}));
    } else {
      print("WebSocket is not connected.");
    }
  }
}
