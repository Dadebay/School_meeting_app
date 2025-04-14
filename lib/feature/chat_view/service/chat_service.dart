// ignore_for_file: strict_raw_type

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/chat_view/model/chat_student_model.dart';
import 'package:okul_com_tm/feature/login/service/auth_provider.dart';
import 'package:okul_com_tm/product/constants/api_constants.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/widgets/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WebSocketStatus { connected, disconnected, error }

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
    bool clearMessages = false,
  }) {
    return ChatState(
      messages: clearMessages ? [] : (messages ?? this.messages),
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
  String? _lastSentMessage;

  /// Objectionable words list
  static const List<String> blockedWords = ['fuck', 'shit', 'bitch', 'asshole', 'bastard', 'damn', 'slut', 'dick', 'nigger', 'fag', 'whore', 'cunt', 'rape', 'kill', 'stupid', 'idiot', 'dumb', 'suck', 'motherfucker'];

  bool _containsObjectionableContent(String text) {
    final lowercase = text.toLowerCase();
    return blockedWords.any((word) => lowercase.contains(word));
  }

  void updateMessageText(String text) {
    state = state.copyWith(messageText: text);
  }

  void clearMessagesAndReset() {
    state = state.copyWith(clearMessages: true, currentPage: 1, hasMore: true);
  }

  static Future<List<ChatStudentModel>> fetchStudents() async {
    final token = await AuthServiceStorage.getToken();
    if (token == null) throw Exception('Authentication token not found.');
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getMessages),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final dynamic decodedData = json.decode(utf8Body);
        if (decodedData is List) {
          return decodedData.map((json) => ChatStudentModel.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Invalid response format.');
        }
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load students: $e');
    }
  }

  Future<void> fetchMessages({required int conversationID, int page = 1}) async {
    if ((page == 1 && state.messages.isNotEmpty && state.currentPage >= 1) || (!state.hasMore && page > 1)) return;

    final token = await AuthServiceStorage.getToken();
    if (token == null) return;

    final url = '${ApiConstants.getConversation}$conversationID?page=$page&size=15';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data is Map && data['results'] is List) {
          final List<dynamic> results = data['results'] as List<dynamic>;
          final newMessages = results.map((msg) => Message.fromJson(msg as Map<String, dynamic>)).toList();
          final updatedMessages = page == 1 ? newMessages : [...newMessages, ...state.messages];

          state = state.copyWith(
            messages: updatedMessages,
            currentPage: page,
            hasMore: newMessages.length >= 15,
          );
        } else if (page > 1) {
          state = state.copyWith(hasMore: false);
        }
      } else if (page > 1) {
        state = state.copyWith(hasMore: false);
      }
    } catch (_) {
      if (page > 1) state = state.copyWith(hasMore: false);
    }
  }

  Future<void> connectWebSocket({
    required int studentID,
    required int myID,
    required ChatStudentModel student,
  }) async {
    if (state.connectionStatus == WebSocketStatus.connected && state.currentStudentID == studentID) return;

    _disconnectWebSocket();

    final wsUrl = _buildWebSocketUrl(student, studentID, myID);

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      state = state.copyWith(connectionStatus: WebSocketStatus.connected, currentStudentID: studentID);

      _subscription = _channel?.stream.listen(
        (message) => _handleIncomingMessage(message, studentID, myID),
        onDone: () => state = state.copyWith(connectionStatus: WebSocketStatus.disconnected),
        onError: (_) => state = state.copyWith(connectionStatus: WebSocketStatus.error),
        cancelOnError: true,
      );
    } catch (_) {
      state = state.copyWith(connectionStatus: WebSocketStatus.error);
    }
  }

  String _buildWebSocketUrl(ChatStudentModel student, int studentID, int myID) {
    switch (student.type) {
      case 'teacher':
        return 'ws://157.173.194.79:9000/ws/chat/$myID/$studentID/$myID/';
      case 'admin':
        return 'ws://157.173.194.79:9000/ws/admin/$myID/$studentID/$myID/';
      default:
        return 'ws://157.173.194.79:9000/ws/chat/$myID/$myID/$studentID/';
    }
  }

  void _handleIncomingMessage(dynamic message, int studentID, int myID) {
    final content = message.toString();

    try {
      final msg = Message(
        content: content,
        createdAt: DateTime.now().toIso8601String(),
        senderId: studentID,
      );

      if (msg.content == _lastSentMessage) return;

      state = state.copyWith(messages: [...state.messages, msg]);
    } catch (_) {
      final fallback = Message(
        content: content,
        createdAt: DateTime.now().toIso8601String(),
        senderId: studentID,
      );

      if (fallback.senderId == myID) return;

      state = state.copyWith(messages: [...state.messages, fallback]);
    }
  }

  void _disconnectWebSocket() {
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    _subscription = null;

    if (state.connectionStatus == WebSocketStatus.connected) {
      state = state.copyWith(connectionStatus: WebSocketStatus.disconnected);
    }
  }

  void sendMessage(String text, int myID, BuildContext context) {
    if (state.connectionStatus != WebSocketStatus.connected || _channel == null) return;
    if (text.trim().isEmpty) return;

    // ❗️ Objectionable content filtering
    if (_containsObjectionableContent(text)) {
      CustomSnackbar.showCustomSnackbar(
        context,
        "Warning",
        "This message contains inappropriate content and will not be sent.",
        ColorConstants.redColor,
      );
      return;
    }

    // ✅ İçerik uygunsa mesajı gönder
    _channel!.sink.add(text);
    _lastSentMessage = text;

    final optimistic = Message(
      content: text,
      createdAt: DateTime.now().toIso8601String(),
      senderId: myID,
    );

    state = state.copyWith(
      messages: [...state.messages, optimistic],
      messageText: '',
    );
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

  Message({
    required this.content,
    required this.createdAt,
    required this.senderId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      senderId: _parseToInt(json['sender_id']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? -1;
    return -1;
  }

  DateTime get dateTime => DateTime.parse(createdAt).toLocal();
}
