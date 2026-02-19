import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/jellyfin_service.dart';
import 'services/player_service.dart';
import 'services/playlist_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MusifynApp());
}

class MusifynApp extends StatelessWidget {
  const MusifynApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JellyfinService()),
        ChangeNotifierProvider(create: (_) => PlayerService()),
        ChangeNotifierProvider(create: (_) => PlaylistService()),
      ],
      child: MaterialApp(
        title: 'Musifyn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF7B2FBE),
            secondary: const Color(0xFF4A90D9),
            surface: const Color(0xFF0D0D1A),
            background: const Color(0xFF080812),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFF080812),
          cardColor: const Color(0xFF12122A),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF080812),
            elevation: 0,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Color(0xFFB3B3C8)),
          ),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final jellyfin = context.read<JellyfinService>();
    await jellyfin.loadSavedSession();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF7B2FBE)),
        ),
      );
    }
    return Consumer<JellyfinService>(
      builder: (context, jellyfin, _) {
        return jellyfin.isAuthenticated ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}
