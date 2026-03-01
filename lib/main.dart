import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/jellyfin_service.dart';
import 'services/player_service.dart';
import 'services/playlist_service.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1DB954),
            secondary: Color(0xFF1ED760),
            tertiary: Color(0xFF148A3C),
            surface: Color(0xFF121212),
            onPrimary: Colors.black,
            onSecondary: Colors.black,
            onSurface: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.transparent,
          fontFamily: 'sans-serif',
          // SuperWonder used selectively for the app title
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
    _init();
  }

  Future<void> _init() async {
    await context.read<JellyfinService>().loadSavedSession();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0A),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
      );
    }
    return Consumer<JellyfinService>(
      builder: (_, jellyfin, __) =>
          jellyfin.isAuthenticated ? const MainShell() : const LoginScreen(),
    );
  }
}
