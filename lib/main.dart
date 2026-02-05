import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shule_direct/providers/chat_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/conversations_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Shule Direct',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA02020)),
          useMaterial3: true,
          textTheme: GoogleFonts.outfitTextTheme(),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/conversations': (context) => const ConversationsScreen(),
          '/chat': (context) => const ChatScreen(),
        },
      ),
    );
  }
}
