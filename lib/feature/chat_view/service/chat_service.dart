// ignore_for_file: strict_raw_type

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/chat_view/model/chat_student_model.dart';
import 'package:okul_com_tm/feature/login/service/auth_provider.dart';
import 'package:okul_com_tm/product/constants/api_constants.dart';
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
    bool clearMessages = false, // Flag to handle clearing messages
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
  void updateMessageText(String text) {
    state = state.copyWith(messageText: text);
  }

  void clearMessagesAndReset() {
    state = state.copyWith(
      clearMessages: true,
      currentPage: 1,
      hasMore: true,
    );
  }

  static Future<List<ChatStudentModel>> fetchStudents() async {
    final token = await AuthServiceStorage.getToken();
    if (token == null) {
      log('Error fetching students: Auth Token is null.');
      throw Exception('Authentication token not found.');
    }
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
          log('Error fetching students: Expected a List but got ${decodedData.runtimeType}');
          throw Exception('Failed to load students: Invalid response format.');
        }
      } else {
        log('Error fetching students: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching students: $e');
      throw Exception('Failed to load students: $e');
    }
  }

  Future<void> fetchMessages({required int conversationID, int page = 1}) async {
    if ((page == 1 && state.messages.isNotEmpty && state.currentPage >= 1) || (!state.hasMore && page > 1)) {
      log("Skipping fetch: page=$page, hasMore=${state.hasMore}, currentMessages=${state.messages.length}");
      return; // Avoid redundant fetches
    }
    final token = await AuthServiceStorage.getToken();
    if (token == null) {
      log('Error fetching messages: Auth Token is null.');
      return;
    }
    final url = '${ApiConstants.getConversation}$conversationID?page=$page&size=15'; // Use size 15 as per logic
    log('Fetching messages from: $url');
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      log('Fetch messages status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)); // Use utf8 decode
        if (data is Map && data.containsKey('results') && data['results'] is List) {
          final List<dynamic> results = data['results'] as List<dynamic>;
          final newMessages = results.map((msg) => Message.fromJson(msg as Map<String, dynamic>)).toList();
          final updatedMessages = page == 1
              ? newMessages // Initial load or refresh of first page
              : [...newMessages, ...state.messages]; // Prepend older messages
          state = state.copyWith(
            messages: updatedMessages,
            currentPage: page,
            hasMore: newMessages.length >= 15, // Determine if more pages might exist
          );
          log('Messages fetched successfully. Page: $page. New count: ${newMessages.length}. Total: ${updatedMessages.length}. HasMore: ${state.hasMore}');
        } else {
          log('Error fetching messages: Invalid response structure. Data: $data');
          if (page > 1) {
            state = state.copyWith(hasMore: false);
          }
        }
      } else {
        log('Error fetching messages: ${response.statusCode}');
        if (page > 1) {
          state = state.copyWith(hasMore: false);
        }
      }
    } catch (e) {
      log('Exception while fetching messages: $e');
      if (page > 1) {
        state = state.copyWith(hasMore: false);
      }
      // Optionally update state to show error
    }
  }

  String? _lastSentMessage;

  Future<void> connectWebSocket({required int studentID, required int myID}) async {
    if (state.connectionStatus == WebSocketStatus.connected && state.currentStudentID == studentID) {
      log('WebSocket already connected to student $studentID');
      return;
    }
    log('Attempting to connect WebSocket for student $studentID...');
    _disconnectWebSocket();
    String wsUrl = "";
    String? status = await AuthServiceStorage.getStatus();
    if (status == 'teacher') {
      wsUrl = 'ws://157.173.194.79:9000/ws/chat/$myID/$studentID/$myID/';
    } else {
      wsUrl = 'ws://157.173.194.79:9000/ws/chat/$myID/$myID/$studentID/';
    }
    log('WebSocket URL: $wsUrl');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      log('WebSocket channel created.');
      state = state.copyWith(
        connectionStatus: WebSocketStatus.connected, // Optimistic? Or set on successful listen?
        currentStudentID: studentID,
      );
      _subscription = _channel?.stream.listen(
        (message) {
          log('WebSocket message received: $message');
          try {
            final messageData = Message.fromJson({
              'content': message.toString(),
              'created_at': DateTime.now().toIso8601String(),
              'sender_id': studentID,
            });
            if (messageData.content == _lastSentMessage) {
              log('Kendi mesajımız tekrar geldi, listeye eklenmedi.');
              return;
            }
            state = state.copyWith(
              messages: [...state.messages, messageData],
            );
          } catch (e) {
            log('Error processing WebSocket message: $e. Message was: $message');
            final newMessage = Message(
              content: message.toString(),
              senderId: studentID,
              createdAt: DateTime.now().toIso8601String(),
            );
            if (newMessage.senderId == myID) {
              log('Ignoring plain text message echo from self.');
              return;
            }
            state = state.copyWith(
              messages: [...state.messages, newMessage],
            );
          }
        },
        onDone: () {
          log('WebSocket connection closed.');
          state = state.copyWith(
            connectionStatus: WebSocketStatus.disconnected,
          );
        },
        onError: (error) {
          log('WebSocket error: $error');
          state = state.copyWith(
            connectionStatus: WebSocketStatus.error,
            // Decide if currentStudentID should be cleared on error
            // currentStudentID: null
          );
        },
        cancelOnError: true, // Close subscription on error
      );
      log('WebSocket stream listening.');
    } catch (e) {
      log('WebSocket connection failed: $e');
      state = state.copyWith(connectionStatus: WebSocketStatus.error);
    }
  }

  void _disconnectWebSocket() {
    if (_channel != null) {
      log('Disconnecting WebSocket...');
      _subscription?.cancel();
      _channel?.sink.close();
      _channel = null;
      _subscription = null;
      // Update state only if it wasn't already disconnected/errored
      if (state.connectionStatus == WebSocketStatus.connected) {
        state = state.copyWith(
          connectionStatus: WebSocketStatus.disconnected,
          // currentStudentID: null // Clear student ID on disconnect
        );
      }
      log('WebSocket disconnected.');
    }
  }

  void sendMessage(String text, int myID) {
    if (state.connectionStatus == WebSocketStatus.connected && _channel != null) {
      if (text.trim().isEmpty) {
        log('Attempted to send empty message.');
        return;
      }

      log('Sending message via WebSocket: $text');
      try {
        // Prepare message payload (Backend might expect JSON)

        _channel!.sink.add(text); // Send JSON string

        // Add message optimistically to UI - Backend echo should be ignored later
        final optimisticMessage = Message(
            content: text.trim(),
            createdAt: DateTime.now().toIso8601String(), // Use UTC? Consistent timezones are important
            senderId: myID // Mark as sent by current user
            );

        _lastSentMessage = optimisticMessage.content; // Track content to ignore echo (less reliable)

        state = state.copyWith(
          messages: [...state.messages, optimisticMessage],
          messageText: '', // Clear input field text via state
        );
        // Do not scroll from here. UI will react.
      } catch (e) {
        log('Error sending WebSocket message: $e');
        // Optionally show error to user
      }
    } else {
      log('Cannot send message: WebSocket not connected.');
      // Optionally show error to user
    }
  }

  @override
  void dispose() {
    log('Disposing ChatNotifier...');
    _disconnectWebSocket();
    super.dispose();
  }
}

// Message Model (ensure it matches backend structure)
class Message {
  final String content;
  final String createdAt; // Store as ISO 8601 String
  final int senderId;
  // Add potentially: messageId (unique), status (sending, sent, delivered, read)

  Message({
    required this.content,
    required this.createdAt,
    required this.senderId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // Perform type checking and handle potential nulls
    return Message(
      content: json['content']?.toString() ?? '', // Handle null content
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(), // Handle null timestamp
      senderId: _parseToInt(json['sender_id']), // Safely parse sender_id
    );
  }

  // Helper function for safe integer parsing
  static int _parseToInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? -1; // Return -1 or throw error on parse failure
    } else {
      return -1; // Default or error value
    }
  }

  // Convert ISO string to DateTime for comparison/display formatting
  DateTime get dateTime => DateTime.parse(createdAt).toLocal(); // Convert to local time for display
}
