import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/chat_view/model/chat_student_model.dart';
import 'package:okul_com_tm/product/widgets/index.dart';
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

  ChatState({
    required this.messages,
    this.messageText = '',
    required this.connectionStatus,
    this.currentStudentID,
  });

  ChatState copyWith({
    List<Message>? messages,
    WebSocketStatus? connectionStatus,
    String? messageText,
    int? currentStudentID,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      messageText: messageText ?? this.messageText,
      currentStudentID: currentStudentID ?? this.currentStudentID,
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

  Future<void> fetchMessages({required int conversationID}) async {
    final token = await AuthServiceStorage.getToken();
    final url = '${ApiConstants.getConversation}$conversationID?page=1&size=10';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final messages = (data['results'] as List).map((msg) => Message.fromJson(msg as Map<String, dynamic>)).toList();
        state = state.copyWith(messages: messages);
      } else {
        log('Error fetching messages: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching messages: $e');
    }
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

  void connectWebSocket({required int studentID, required int myID}) {
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
          print("Gelen Mesaj: $message");
          final decoded = message.toString();
          bool value = false;
          final now = DateTime.now();
          final nowFormatted = "${now.hour}:${now.minute}"; // Sadece saat ve dakika bazlı karşılaştırma

          for (var element in state.messages) {
            final messageTime = DateTime.tryParse(element.createdAt);
            final messageFormatted = messageTime != null ? "${messageTime.hour}:${messageTime.minute}" : "";

            print("Karşılaştırma - Gelen: $decoded, Kayıtlı: ${element.content}");
            print("Zaman Karşılaştırması - Gelen: $nowFormatted, Kayıtlı: $messageFormatted");

            if (element.content == decoded && messageFormatted == nowFormatted) {
              value = true;
              break; // Eğer eşleşme bulunduysa döngüden çık
            }
          }

          print("Tekrar Ediyor mu?: $value");

          if (!value) {
            final newMessage = Message.fromJson({
              'content': decoded,
              'created_at': now.toIso8601String(),
              'sender_id': studentID,
            });

            state = state.copyWith(
              messages: [...state.messages, newMessage],
            );
          }
        },
        onDone: () {
          state = state.copyWith(connectionStatus: WebSocketStatus.disconnected);
          print('WebSocket bağlantısı kapandı ❌');
        },
        onError: (error) {
          state = state.copyWith(connectionStatus: WebSocketStatus.error);
          print('WebSocket bağlantı hatası: $error 🚨');
        },
      );
    } catch (e) {
      state = state.copyWith(connectionStatus: WebSocketStatus.error);
      print('WebSocket bağlantı kurulamadı: $e');
    }
  }

  void _disconnectWebSocket() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }

    if (_channel != null) {
      try {
        _channel!.sink.close();
      } catch (e) {
        print('WebSocket kapatılırken hata: $e');
      } finally {
        _channel = null;
      }
    }

    state = state.copyWith(connectionStatus: WebSocketStatus.disconnected);
  }

  void sendMessage(String text, int myID) {
    if (state.connectionStatus == WebSocketStatus.connected && _channel != null) {
      try {
        _channel!.sink.add(text);

        final now = DateTime.now().toIso8601String(); // Kesin tarih formatı

        final newMessage = Message.fromJson({
          'content': text,
          'created_at': now,
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
