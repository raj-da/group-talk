import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouptalk/features/chat/domain/entity/message_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:grouptalk/core/core/Route/route_name.dart';
import 'package:grouptalk/features/chat/presentation/bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String userId;
  final String userName;

  const ChatPage({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.userId,
    required this.userName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Toggle state for the AI Assistant button
  bool _isActive = false;

  final TextEditingController _textController = TextEditingController();

  // (Messages come from the bloc state — no local dummy list needed)

  void _sendMessage() {
    debugPrint('_isActive == $_isActive ---------------------------------->');
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    debugPrint('_sendAiMessage ---------------------------------------->');
    context.read<ChatBloc>().add(
      SendUserMessageEvent(
        message: MessageEntity(
          id: '',
          roomId: widget.roomId,
          senderId: widget.userId,
          senderName: widget.userName,
          content: text,
          isAI: false,
          createdAt: DateTime.now(),
        ),
      ),
    );

    if (_isActive) {
      debugPrint(
        'if Case in _sendMessage ----------------------------------------->',
      );
      context.read<ChatBloc>().add(
        SendAiMessageEvent(roomId: widget.roomId, prompt: text),
      );
    }

    _textController.clear();
  }

  void _sendAiMessage() {
    debugPrint('_isActive == $_isActive ---------------------------------->');
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // _sendMessage();
    debugPrint('_sendAiMessage ---------------------------------------->');
    context.read<ChatBloc>().add(
      SendAiMessageEvent(prompt: text, roomId: widget.roomId),
    );

    if (_isActive) {
      debugPrint(
        'If case in _sendAiMessage() ------------------------------------>',
      );
      context.read<ChatBloc>().add(
        SendAiMessageEvent(roomId: widget.roomId, prompt: text),
      );
    }

    _textController.clear();
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent(roomId: widget.roomId));
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF00897B); // Teal-ish Green
    const Color secondaryGreen = Color(0xFF00796B); // Darker Teal

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.goNamed(RouteName.home),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.roomName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),

      body: Column(
        children: [
          // Custom AI Toggle Header
          Container(
            color: primaryGreen,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isActive = !_isActive;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isActive ? Colors.cyan[600] : secondaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _isActive ? "AI Assistant Active" : "Ask AI Assistant",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Chat List
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatError) {
                  return Center(child: Text(state.message));
                }

                final messages = switch (state) {
                  ChatLoaded s => s.messages,
                  ChatSending s => s.messages,
                  _ => <MessageEntity>[],
                };

                final isAiAnalyzing = state is ChatSending && state.isAi;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (isAiAnalyzing ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < messages.length) {
                      final msg = messages[index];
                      return buildMessageBubble(
                        sender: msg.senderName,
                        message: msg.content,
                        time: msg.createdAt.toString(),
                        type: msg.isAI
                            ? MessageType.ai
                            : msg.senderId == widget.userId
                            ? MessageType.user
                            : MessageType.other,
                      );
                    } else {
                      return const AIAnalyzingWidget();
                    }
                  },
                );
              },
            ),
          ),

          // Input Area
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _isActive ? _sendAiMessage : _sendMessage,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable Message Bubble Component
// ---------------------------------------------------------------------------

Widget buildMessageBubble({
  required String sender,
  required String message,
  required String time,
  required MessageType type,
  MessageStatus? status,
}) {
  bool isUser = type == MessageType.user;
  bool isAI = type == MessageType.ai;

  Color bubbleColor;
  Color textColor;
  if (isUser) {
    bubbleColor = const Color(0xFF00897B); // User Green
    textColor = Colors.white;
  } else if (isAI) {
    bubbleColor = const Color(0xFFE0F7FA); // AI Light Blue
    textColor = Colors.black87;
  } else {
    bubbleColor = Colors.white; // Other User White
    textColor = Colors.black87;
  }
  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      constraints: const BoxConstraints(maxWidth: 300), // Max width of bubble
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Only show Sender Name for AI or Other users
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isAI)
                    const Icon(
                      Icons.auto_awesome,
                      size: 14,
                      color: Colors.teal,
                    ),
                  if (isAI) const SizedBox(width: 4),
                  Text(
                    sender,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isAI ? Colors.teal : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

          // The Message Bubble
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: isUser
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
                bottomRight: isUser
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
              border: isAI ? Border.all(color: Colors.cyan[100]!) : null,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: TextStyle(color: textColor, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        color: isUser ? Colors.white70 : Colors.grey[600],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status Indicator (Sending / Sent)
          if (isUser && status != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 4),
              child: status == MessageStatus.sending
                  ? const SendingIdicator()
                  : const Icon(Icons.check, size: 12, color: Colors.grey),
            ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Custom Status Widgets
// ---------------------------------------------------------------------------

class SendingIdicator extends StatelessWidget {
  const SendingIdicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 4,
      child: LinearProgressIndicator(
        backgroundColor: Colors.grey[300],
        color: const Color(0xFF00897B),
        minHeight: 2,
      ),
    );
  }
}

class AIAnalyzingWidget extends StatelessWidget {
  const AIAnalyzingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.cyan[100]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 16, color: Colors.teal),
            const SizedBox(width: 8),
            const Text(
              "AI is Analyzing...",
              style: TextStyle(color: Colors.teal, fontStyle: FontStyle.italic),
            ),
            const SizedBox(width: 8),
            const SizedBox(
              width: 12,
              height: 12,
              child: LinearProgressIndicator(color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}

// Enums for cleaner logic
enum MessageType { user, other, ai }

enum MessageStatus { sending, sent }
