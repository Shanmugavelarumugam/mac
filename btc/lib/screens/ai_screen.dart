import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiScreen extends StatefulWidget {
  @override
  _AiScreenState createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({"role": "user", "content": message});
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY',
        },
        body: json.encode({"model": "gpt-3.5-turbo", "messages": _messages}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply = data['choices'][0]['message']['content'];

        setState(() {
          _messages.add({"role": "assistant", "content": reply});
        });
      } else {
        setState(() {
          _messages.add({
            "role": "assistant",
            "content": "❌ Error: ${response.body}",
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "assistant",
          "content": "⚠️ Failed to connect to AI",
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }

    _controller.clear();
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

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isUser ? Colors.teal[100] : Colors.grey[300];
    final textColor = Colors.black87;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(0, 1.5),
            ),
          ],
        ),
        child: Text(
          message['content'] ?? '',
          style: TextStyle(fontSize: 16, height: 1.4, color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'AI Assistant',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _messages.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.smart_toy_outlined,
                              color: Colors.teal,
                              size: 64,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Hi! I'm your AI Assistant",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Type your question below to get started.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemBuilder: (context, index) {
                        return _buildMessage(_messages[index]);
                      },
                    ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(color: Colors.teal),
            ),
          const Divider(height: 1),
          SafeArea(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Ask something...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          sendMessage(value.trim());
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      if (_controller.text.trim().isNotEmpty) {
                        sendMessage(_controller.text.trim());
                      }
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 22,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
