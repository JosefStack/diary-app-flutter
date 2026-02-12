import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Import local services and providers
import 'providers/auth_provider.dart';
import 'providers/entry_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ygocvxeajyqqbrxujzlf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlnb2N2eGVhanlxcWJyeHVqemxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4NDc3MjgsImV4cCI6MjA4NjQyMzcyOH0.K7ydlYMgMiYN9saXtDLxeHVOmGUlnVI56PXhUwWjgig',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EntryProvider()),
      ],
      child: const LuminaApp(),
    ),
  );
}

class LuminaApp extends StatelessWidget {
  const LuminaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111827),
        primaryColor: const Color(0xFF10B981),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF10B981),
          secondary: const Color(0xFFF59E0B),
          surface: const Color(0xFF1F2937),
          background: const Color(0xFF111827),
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            return const DashboardScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
