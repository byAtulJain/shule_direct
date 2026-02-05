import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.token != null) {
        Provider.of<ChatProvider>(context, listen: false).fetchConversations(auth.token!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Groups', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'Form - ${authProvider.user?.formsId ?? 1}',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 18),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              authProvider.user?.username != null && authProvider.user!.username!.isNotEmpty
                  ? authProvider.user!.username![0].toUpperCase()
                  : '?',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 16),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages or users',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          
          Expanded(
            child: chatProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : chatProvider.conversations.isEmpty
                    ? const Center(child: Text('No Groups Found', style: TextStyle(color: Colors.grey, fontSize: 16)))
                    : ListView.builder(
                        itemCount: chatProvider.conversations.length,
                        itemBuilder: (context, index) {
                          final chat = chatProvider.conversations[index];
                          final name = chat['name'] ?? chat['group_name'] ?? 'Chemistry Group'; 
                          final lastMessage = chat['last_message'] ?? 'Group created by you';
                          final time = '12 min'; 
                          
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.pink.shade100,
                              child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.brown)),
                            ),
                            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            onTap: () {
                              Navigator.pushNamed(
                                context, 
                                '/chat', 
                                arguments: {'id': chat['id'].toString(), 'name': name}
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
