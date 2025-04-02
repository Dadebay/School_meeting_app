import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/chat_view/model/chat_student_model.dart';
import 'package:okul_com_tm/product/widgets/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// WebSocket bağlantı durumlarını temsil eden enum
enum WebSocketStatus { connected, disconnected, error }

// Chat Provider - WebSocket durumu da takip ediliyor
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>(
  (ref) => ChatNotifier(),
);

class ChatState {
  final List<Message> messages;
  final WebSocketStatus connectionStatus;
  final String messageText;
  final int? currentStudentID;
  final int currentPage;
  final bool hasMore;

  ChatState({
    required this.messages,
    this.messageText = '',
    required this.connectionStatus,
    this.currentStudentID,
    this.currentPage = 1,
    this.hasMore = true,
  });

  ChatState copyWith({
    List<Message>? messages,
    WebSocketStatus? connectionStatus,
    String? messageText,
    int? currentStudentID,
    int? currentPage,
    bool? hasMore,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      messageText: messageText ?? this.messageText,
      currentStudentID: currentStudentID ?? this.currentStudentID,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState(messages: [], connectionStatus: WebSocketStatus.disconnected));

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  void updateMessageText(String text) {
    state = state.copyWith(messageText: text);
  }

  static Future<List<ChatStudentModel>> fetchStudents() async {
    final token = await AuthServiceStorage.getToken();

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getMessages),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(utf8Body) as List<dynamic>;
        return data.map((json) => ChatStudentModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load students: $e');
    }
  }

  Future<void> fetchMessages({required int conversationID, int page = 1}) async {
    if (!state.hasMore && page > 1) return;

    final token = await AuthServiceStorage.getToken();
    final url = '${ApiConstants.getConversation}$conversationID?page=$page&size=15';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newMessages = (data['results'] as List).map((msg) => Message.fromJson(msg as Map<String, dynamic>)).toList();

        state = state.copyWith(
          messages: page == 1 ? newMessages : [...state.messages, ...newMessages],
          currentPage: page,
          hasMore: newMessages.length >= 15, // 15 mesajdan az gelirse daha fazla yok demektir
        );
      } else {
        log('Error fetching messages: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching messages: $e');
    }
  }

  void loadMoreMessages(int conversationID) async {
    await fetchMessages(conversationID: conversationID, page: state.currentPage + 1);
    refreshController.loadComplete();
  }

  void _scrollToBottom(ScrollController _scrollController) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  void connectWebSocket({required int studentID, required int myID, required ScrollController scrollController}) {
    if (state.connectionStatus == WebSocketStatus.connected && state.currentStudentID == studentID) {
      return;
    }

    _disconnectWebSocket();

    final wsUrl = 'ws://157.173.194.79:9000/ws/chat/$myID/$studentID/$myID/';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      state = state.copyWith(
        connectionStatus: WebSocketStatus.connected,
        currentStudentID: studentID,
      );
      _subscription = _channel?.stream.listen(
        (message) {
          final newMessage = Message.fromJson({
            'content': message.toString(),
            'created_at': DateTime.now().toIso8601String(),
            'sender_id': studentID,
          });

          _scrollToBottom(scrollController);

          state = state.copyWith(
            messages: [...state.messages, newMessage],
          );
        },
        onDone: () => state = state.copyWith(connectionStatus: WebSocketStatus.disconnected),
        onError: (error) => state = state.copyWith(connectionStatus: WebSocketStatus.error),
      );
    } catch (e) {
      state = state.copyWith(connectionStatus: WebSocketStatus.error);
      print('WebSocket bağlantı kurulamadı: $e');
    }
  }

  void _disconnectWebSocket() {
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
    state = state.copyWith(connectionStatus: WebSocketStatus.disconnected);
  }

  void sendMessage(String text, int myID) {
    if (state.connectionStatus == WebSocketStatus.connected && _channel != null) {
      try {
        _channel!.sink.add(text);

        final newMessage = Message.fromJson({
          'content': text,
          'created_at': DateTime.now().toIso8601String(),
          'sender_id': myID,
        });

        state = state.copyWith(
          messages: [...state.messages, newMessage],
          messageText: '',
        );
      } catch (e) {
        log('Mesaj gönderme hatası: $e');
      }
    } else {
      log('Mesaj gönderilemedi, WebSocket bağlı değil ❌');
    }
  }

  @override
  void dispose() {
    _disconnectWebSocket();
    super.dispose();
  }
}

class Message {
  final String content;
  final String createdAt;
  final int senderId;

  Message({required this.content, required this.createdAt, required this.senderId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'].toString(),
      createdAt: json['created_at'].toString(),
      senderId: json['sender_id'] as int,
    );
  }
}
