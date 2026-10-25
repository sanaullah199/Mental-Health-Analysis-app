import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_loader.dart';
import 'package:mental_health_analysis_app/ui/screens/chat/chat_view_model.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isSidebarOpen = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel()..initialize(),
      child: Consumer<ChatViewModel>(
        builder: (context, model, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (model.messages.isNotEmpty) {
              _scrollToBottom();
            }
          });

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: Stack(
              children: [
                // Main chat area
                Column(
                  children: [
                    _buildAppBar(context, model),
                    Expanded(
                      child: model.state == ViewState.busy
                          ? Center(child: CustomLoader(color: primaryColor))
                          : model.messages.isEmpty
                          ? _buildEmptyChat()
                          : _buildMessagesList(model),
                    ),
                    _buildMessageInput(context, model),
                  ],
                ),
                // Sidebar overlay
                if (_isSidebarOpen)
                  GestureDetector(
                    onTap: () => setState(() => _isSidebarOpen = false),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                // Sidebar
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  left: _isSidebarOpen ? 0 : -280,
                  top: 0,
                  bottom: 0,
                  width: 280,
                  child: _buildSidebar(context, model),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ChatViewModel model) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(color: Color(0xff9BB068)),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                "${AppAssets.imagePath}/chat_bot.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mindfull AI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  model.assessment != null
                      ? "Score: ${model.assessment!.aiScore}/100"
                      : "Here to support you",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => model.startNewConversation(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, ChatViewModel model) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Sidebar header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff9BB068),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    "Conversations",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => setState(() => _isSidebarOpen = false),
                  ),
                ],
              ),
            ),
            // New conversation button
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                onPressed: () {
                  model.startNewConversation();
                  setState(() => _isSidebarOpen = false);
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text("New Chat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFE814B),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            // Conversations list
            Expanded(
              child: model.conversations.isEmpty
                  ? Center(
                      child: Text(
                        "No conversations yet",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: model.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = model.conversations[index];
                        final isActive =
                            conversation.id == model.currentConversationId;
                        return _buildConversationItem(
                          context,
                          model,
                          conversation,
                          isActive,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationItem(
    BuildContext context,
    ChatViewModel model,
    conversation,
    bool isActive,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff9BB068).withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Text(
          conversation.moodEmoji,
          style: const TextStyle(fontSize: 20),
        ),
        title: Text(
          conversation.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${conversation.messageCount} messages",
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, size: 18, color: Colors.grey[600]),
          onSelected: (value) {
            if (value == 'delete') {
              model.deleteConversation(conversation.id);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          model.switchConversation(conversation.id);
          setState(() => _isSidebarOpen = false);
        },
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "${AppAssets.imagePath}/bot.png",
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Limited Knowledge",
                style: headingTextStyle.copyWith(
                  fontSize: 24,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "No human being is perfect. So is chatbots. Mindfull AI knowledge is limted to 2025.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(ChatViewModel model) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: model.messages.length + (model.isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == model.messages.length) {
          return _buildTypingIndicator();
        }

        final message = model.messages[index];
        final showDate =
            index == 0 ||
            _shouldShowDateSeparator(
              model.messages[index - 1].timestamp,
              message.timestamp,
            );

        return Column(
          children: [
            if (showDate) _buildDateSeparator(message.timestamp),
            FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: _buildMessageBubble(message),
            ),
          ],
        );
      },
    );
  }

  bool _shouldShowDateSeparator(DateTime prev, DateTime current) {
    return prev.day != current.day ||
        prev.month != current.month ||
        prev.year != current.year;
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.day == now.day && date.month == now.month && date.year == now.year;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              isToday ? "Today" : "${date.day}/${date.month}/${date.year}",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Column(
      crossAxisAlignment: isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8DDD9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology,
                  size: 24,
                  color: Color(0xff9BB068),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUser
                      ? const Color(0xff4B3425)
                      : const Color(0xffE8DDD9),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isUser
                        ? const Radius.circular(16)
                        : const Radius.circular(4),
                    bottomRight: isUser
                        ? const Radius.circular(4)
                        : const Radius.circular(16),
                  ),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.grey[800],
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: 8),
              Image.asset(
                "${AppAssets.iconsPath}/person_chat.png",
                width: 32,
                height: 32,
              ),
            ],
          ],
        ),
        if (isUser &&
            message.emotion != null &&
            message.dataUpdated == true) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: message.emotionColor ?? Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_emotions, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  "Emotion: ${message.emotion}. Data Updated.",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xffE8E8E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.psychology,
              size: 18,
              color: Color(0xff9BB068),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xffE8E8E8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = (value - delay).clamp(0.0, 1.0);
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color(0xff9BB068).withValues(alpha: 0.3 + (animValue * 0.7)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: "Type to start chatting...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onTap: _scrollToBottom,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xff9BB068),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    model.sendMessage(_controller.text.trim());
                    _controller.clear();
                    _scrollToBottom();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? emotion;
  final Color? emotionColor;
  final bool? dataUpdated;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.emotion,
    this.emotionColor,
    this.dataUpdated,
  });
}
