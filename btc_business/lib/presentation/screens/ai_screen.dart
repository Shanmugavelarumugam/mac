import 'package:flutter/material.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> with TickerProviderStateMixin {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          isUser: true,
          animationController: _createAnimation(),
        ),
      );
      _messages.add(
        _ChatMessage(
          text: "This is an AI response to: \"$text\"",
          isUser: false,
          animationController: _createAnimation(),
        ),
      );
    });

    _controller.clear();
    _scrollToBottom();
  }

  AnimationController _createAnimation() {
    return AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    for (final msg in _messages) {
      msg.animationController.dispose();
    }
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Financial Assistant'),
        backgroundColor: Colors.teal.shade700,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFF80CBC4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return SizeTransition(
                    sizeFactor: CurvedAnimation(
                      parent: msg.animationController,
                      curve: Curves.easeOut,
                    ),
                    axisAlignment: 0.0,
                    child: Align(
                      alignment:
                          msg.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient:
                              msg.isUser
                                  ? LinearGradient(
                                    colors: [
                                      Colors.teal.shade400,
                                      Colors.teal.shade700,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                  : LinearGradient(
                                    colors: [
                                      Colors.grey.shade200,
                                      Colors.grey.shade400,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(msg.isUser ? 20 : 4),
                            bottomRight: Radius.circular(msg.isUser ? 4 : 20),
                          ),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.isUser ? Colors.white : Colors.black87,
                            fontSize: 16,
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Segoe UI',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1, thickness: 1.2),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.teal.shade600,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: _sendMessage,
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final AnimationController animationController;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.animationController,
  });
}
