import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? conversationId;
  String? groupName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && conversationId == null) {
      conversationId = args['id'];
      groupName = args['name'];
      
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.token != null && conversationId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<ChatProvider>(context, listen: false).enterChat(auth.token!, conversationId!);
        });
      }
    }
  }

  @override
  void dispose() {
    Provider.of<ChatProvider>(context, listen: false).leaveChat();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100, 
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(groupName ?? 'Group Chat', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('20 Online', style: TextStyle(fontSize: 12, color: Colors.grey)), 
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = chatProvider.messages[index];
                    final isMe = msg['is_me'] ?? false; 
                    final content = msg['message'] ?? msg['content'] ?? '';
                    final sender = msg['sender'] ?? 'User'; 
                    final time = '10:05'; 

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.white : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: isMe ? Border.all(color: Colors.grey.shade300) : null,
                          boxShadow: [
                            if (isMe) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isMe) Text(sender, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(content, style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Enter Message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ), 
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xFFA02020)),
                  onPressed: () {},
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFA02020),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_msgController.text.isNotEmpty) {
                        chatProvider.sendMessage(_msgController.text);
                        _msgController.clear();
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
