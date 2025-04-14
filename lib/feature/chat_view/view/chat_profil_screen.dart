import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/chat_view/model/chat_student_model.dart';
import 'package:okul_com_tm/feature/chat_view/service/chat_service.dart';
import 'package:okul_com_tm/feature/login/service/auth_provider.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/dialogs/dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ChatStudentModel model;
  const ChatScreen({Key? key, required this.model}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  int? _myID;

  @override
  void initState() {
    super.initState();
    log("ChatScreen initState for student ${widget.model.id}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    log("Initializing chat...");
    final userIDString = await AuthServiceStorage.getUserID();
    if (userIDString == null) {
      log("Error: Could not get User ID. Aborting chat initialization.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: Unable to verify user.")));
        Navigator.of(context).pop();
      }
      return;
    }
    _myID = int.tryParse(userIDString);
    if (_myID == null) {
      log("Error: User ID '$userIDString' is not a valid integer.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: Invalid user data.")));
        Navigator.of(context).pop();
      }
      return;
    }
    log("User ID: $_myID, Target Student ID: ${widget.model.id}, Conversation ID: ${widget.model.conversationID}");
    final notifier = ref.read(chatProvider.notifier);
    notifier.clearMessagesAndReset();
    await notifier.fetchMessages(conversationID: widget.model.conversationID, page: 1);
    notifier.connectWebSocket(studentID: widget.model.id, myID: _myID!, student: widget.model);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    log("Chat initialization complete.");
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    log("Scrolled to bottom (0.0)");
  }

  Future<void> _loadMoreMessages() async {
    final notifier = ref.read(chatProvider.notifier);
    final currentState = ref.read(chatProvider);
    if (!currentState.hasMore) {
      log("No more messages to load.");
      _refreshController.loadNoData();
      return;
    }
    log("Loading more messages, current page: ${currentState.currentPage}");
    await notifier.fetchMessages(conversationID: widget.model.conversationID, page: currentState.currentPage + 1);
    final newState = ref.read(chatProvider);
    if (mounted) {
      if (newState.hasMore) {
        _refreshController.refreshCompleted();
        log("Load more completed.");
      } else {
        _refreshController.loadNoData();
        log("Load more completed, no more data found.");
      }
    }
  }

  @override
  void dispose() {
    log("Disposing ChatScreen");
    _controller.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final notifier = ref.read(chatProvider.notifier);
    final sortedMessages = List<Message>.from(chatState.messages)..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    final isConnected = chatState.connectionStatus == WebSocketStatus.connected;
    final isConnecting = chatState.connectionStatus == null;
    final hasError = chatState.connectionStatus == WebSocketStatus.error;
    ref.listen<ChatState>(chatProvider, (previous, next) {
      if (previous != null && next.messages.length > previous.messages.length) {
        if (_scrollController.hasClients && _scrollController.position.extentBefore < 100) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        }
      }
    });

    return Scaffold(
      appBar: _buildAppBar(context, isConnected, hasError, isConnecting),
      body: Column(
        children: [
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: chatState.hasMore,
              enablePullUp: false,
              onRefresh: _loadMoreMessages,
              header: const WaterDropHeader(),
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: sortedMessages.length,
                itemBuilder: (context, index) {
                  final message = sortedMessages[index];

                  final bool isCurrentUser = _myID != null && message.senderId == _myID;
                  return ChatBubble(message: message, isCurrentUser: isCurrentUser);
                },
              ),
            ),
          ),
          _buildMessageInput(context, notifier, chatState, isConnected),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isConnected, bool hasError, bool isConnecting) {
    String statusText = '';
    Color statusColor = Colors.white70;
    if (isConnecting) {
      statusText = 'Connecting...';
    } else if (hasError) {
      statusText = 'Connection error';
      statusColor = Colors.orange;
    } else if (!isConnected) {
      statusText = 'Disconnected';
      statusColor = Colors.red;
    }

    return AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(IconlyLight.arrow_left_circle, color: ColorConstants.whiteColor),
        ),
        backgroundColor: ColorConstants.primaryBlueColor,
        actions: [
          IconButton(
            icon: Icon(Icons.flag_outlined, color: Colors.white),
            onPressed: () => Dialogs().showReportDialog(context, widget.model.username),
          )
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.model.username,
              style: context.general.textTheme.titleLarge?.copyWith(color: ColorConstants.whiteColor, fontWeight: FontWeight.bold),
            ),
            if (statusText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  statusText,
                  style: context.general.textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ));
  }

  Widget _buildMessageInput(BuildContext context, ChatNotifier notifier, ChatState chatState, bool isConnected) {
    if (_controller.text != chatState.messageText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = chatState.messageText;

          _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
        }
      });
    }

    return Container(
      margin: context.padding.normal,
      padding: context.padding.low.copyWith(left: 20),
      decoration: BoxDecoration(color: ColorConstants.greyColorwithOpacity, border: Border.all(color: ColorConstants.primaryBlueColor.withOpacity(.3)), borderRadius: context.border.normalBorderRadius),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: notifier.updateMessageText,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              style: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.blackColor, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: 'Message...',
                hintStyle: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.greyColor, fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: isConnected && chatState.messageText.trim().isNotEmpty ? Icon(IconlyBold.send, color: ColorConstants.primaryBlueColor) : Icon(IconlyLight.send, color: ColorConstants.greyColor),
            onPressed: isConnected && chatState.messageText.trim().isNotEmpty && _myID != null
                ? () {
                    final textToSend = chatState.messageText.trim();
                    log("Send button pressed. Text: $textToSend");
                    notifier.sendMessage(textToSend, _myID!, context);

                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;

  const ChatBubble({Key? key, required this.message, required this.isCurrentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: context.padding.low,
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isCurrentUser ? ColorConstants.primaryBlueColor : ColorConstants.greyColor.withOpacity(0.15),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isCurrentUser ? const Radius.circular(15) : const Radius.circular(0),
            bottomRight: isCurrentUser ? const Radius.circular(0) : const Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message.content, style: context.general.textTheme.bodyMedium?.copyWith(color: isCurrentUser ? ColorConstants.whiteColor : ColorConstants.blackColor)),
            const SizedBox(height: 4),
            Text(_formatDate(message.dateTime), style: TextStyle(fontSize: 10, color: isCurrentUser ? Colors.white70 : Colors.black54)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}
