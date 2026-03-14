import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/models/mock_models.dart';
import 'emotional_aid_sheet.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String matchId;

  const ChatScreen({super.key, required this.matchId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final UserModel _chatUser;

  // Mock Messages State
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hey! How are you?',
      'senderId': 'other',
      'time': DateTime.now().subtract(const Duration(minutes: 60)),
    },
    {
      'text': 'I saw you like hiking too! That\'s awesome.',
      'senderId': 'other',
      'time': DateTime.now().subtract(const Duration(minutes: 59)),
    },
    {
      'text': 'Hi! Yes, I love it. Do you have a favorite trail?',
      'senderId': 'me',
      'time': DateTime.now().subtract(const Duration(minutes: 30)),
    },
  ];

  bool _isTyping = false;
  bool _hasShownFeelingPrompt = false;
  String? _myFeeling;

  @override
  void initState() {
    super.initState();
    _chatUser = MockData.users.firstWhere(
      (u) => u.id == widget.matchId,
      orElse: () => MockData.users.first,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFeelingPrompt();
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isTyping = true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isTyping = false;
            _messages.add({
              'text': 'I really like the Blue Ridge Mountains. Have you been?',
              'senderId': 'other',
              'time': DateTime.now(),
            });
          });
          _scrollToBottom();
        }
      });
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'senderId': 'me', 'time': DateTime.now()});
    });
    _controller.clear();
    _scrollToBottom();

    // Auto-reply simulation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _isTyping = true);
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'text': 'That sounds great! We should go sometime.',
            'senderId': 'other',
            'time': DateTime.now(),
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleFeelingSubmit(String feeling) {
    setState(() {
      _myFeeling = feeling;
      _messages.insert(0, {
        'text': 'is feeling $feeling about this connection',
        'senderId': 'system',
        'time': DateTime.now(),
        'type': 'feeling',
      });
    });
    _scrollToBottom();
  }

  void _openFeelingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 80,
          ),
          child: FeelingPromptSheet(onSubmit: _handleFeelingSubmit),
        );
      },
    );
  }

  void _showFeelingPrompt() {
    if (_hasShownFeelingPrompt) return;
    _hasShownFeelingPrompt = true;
    _openFeelingDialog();
  }

  void _showEmotionalAid() {
    _openFeelingDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_chatUser.imageUrls.first),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_chatUser.name, style: const TextStyle(fontSize: 16)),
                Text(
                  _isTyping ? 'Typing...' : 'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isTyping ? const Color(0xFFE94057) : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology, color: Color(0xFFE94057)),
            onPressed: _showEmotionalAid,
            tooltip: 'Emotional Aid',
          ),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final type = msg['type'] as String?;
                if (type == 'feeling') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE94057).withAlpha(77),
                          ),
                        ),
                        child: Text(
                          'You are feeling ${_myFeeling ?? ''}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFE94057),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                final isMe = msg['senderId'] == 'me';
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFE94057) : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: isMe
                            ? const Radius.circular(20)
                            : const Radius.circular(0),
                        bottomRight: isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.grey),
                      SizedBox(width: 4),
                      Icon(Icons.circle, size: 8, color: Colors.grey),
                      SizedBox(width: 4),
                      Icon(Icons.circle, size: 8, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(26),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFFE94057)),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE94057),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
