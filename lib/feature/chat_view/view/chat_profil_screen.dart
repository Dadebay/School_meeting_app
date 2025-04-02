import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/chat_view/model/chat_student_model.dart';
import 'package:okul_com_tm/feature/chat_view/service/chat_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ChatStudentModel model;

  ChatScreen({Key? key, required this.model}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  String? myID = '';
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  Future<void> _initializeChat() async {
    myID = await AuthServiceStorage.getUserID();
    ref.read(chatProvider).messages.clear();
    await _fetchInitialMessages();
    ref.read(chatProvider.notifier).connectWebSocket(studentID: widget.model.id, myID: int.parse(myID!), scrollController: _scrollController);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _fetchInitialMessages() async {
    print("Mana geldi-------------------------------------------------");
    _currentPage = 1;
    await ref.read(chatProvider.notifier).fetchMessages(
          conversationID: widget.model.conversationID,
          page: _currentPage,
        );
  }

  Future<void> _loadMoreMessages() async {
    _currentPage++;
    await ref.read(chatProvider.notifier).fetchMessages(
          conversationID: widget.model.conversationID,
          page: _currentPage,
        );
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final isConnected = chatState.connectionStatus == WebSocketStatus.connected;
    final sortedMessages = List.of(chatState.messages)..sort((a, b) => DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: _loadMoreMessages,
              onLoading: _loadMoreMessages,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: sortedMessages.length,
                itemBuilder: (context, index) {
                  final message = sortedMessages[index];
                  final bool isCurrentUser = message.senderId.toString() == myID!;
                  return ChatBubble(message: message, isCurrentUser: isCurrentUser);
                },
              ),
            ),
          ),
          _buildMessageInput(context, chatState, isConnected),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(IconlyLight.arrow_left_circle, color: ColorConstants.whiteColor),
      ),
      backgroundColor: ColorConstants.primaryBlueColor,
      title: Text(
        widget.model.username,
        style: context.general.textTheme.headlineMedium!.copyWith(color: ColorConstants.whiteColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatState chatState, bool isConnected) {
    return Container(
      margin: context.padding.normal,
      padding: context.padding.low.copyWith(left: 20),
      decoration: BoxDecoration(color: ColorConstants.greyColorwithOpacity, border: Border.all(color: ColorConstants.primaryBlueColor.withOpacity(.3)), borderRadius: context.border.normalBorderRadius),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (text) => ref.read(chatProvider.notifier).updateMessageText(text),
              style: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.blackColor, fontSize: 20, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.greyColor, fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: chatState.messageText.isNotEmpty ? Icon(IconlyBold.send, color: ColorConstants.primaryBlueColor) : Icon(IconlyLight.send, color: ColorConstants.greyColor),
            onPressed: isConnected && chatState.messageText.isNotEmpty
                ? () {
                    ref.read(chatProvider.notifier).sendMessage(_controller.text.trim(), int.parse(myID!));
                    _controller.clear();
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
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: context.padding.low,
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isCurrentUser ? ColorConstants.primaryBlueColor : ColorConstants.greyColorwithOpacity,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isCurrentUser ? Radius.circular(15) : Radius.circular(0),
            bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(15),
          ),
        ),
        child: Wrap(
          alignment: isCurrentUser ? WrapAlignment.end : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(message.content, maxLines: 10, style: context.general.textTheme.bodyLarge?.copyWith(color: isCurrentUser ? ColorConstants.whiteColor : ColorConstants.blackColor)),
            Container(margin: EdgeInsets.only(left: 10), child: Text(_formatDate(message.createdAt), style: TextStyle(fontSize: 10, color: isCurrentUser ? Colors.white70 : Colors.black54))),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
