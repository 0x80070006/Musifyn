import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/jellyfin_service.dart';
import '../widgets/mini_player.dart';
import 'library_screen.dart';
import 'search_screen.dart';
import 'playlists_screen.dart';
import 'home_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const SearchScreen(),
    const LibraryScreen(),
    const PlaylistsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          const Positioned(
            left: 0, right: 0, bottom: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D0D1A), Color(0xFF080812)],
          ),
          border: Border(top: BorderSide(color: Color(0xFF1A1A3A), width: 1)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF7B2FBE).withOpacity(0.3),
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Color(0xFF8888AA)),
              selectedIcon: Icon(Icons.home, color: Color(0xFF7B2FBE)),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: Color(0xFF8888AA)),
              selectedIcon: Icon(Icons.search, color: Color(0xFF7B2FBE)),
              label: 'Recherche',
            ),
            NavigationDestination(
              icon: Icon(Icons.library_music_outlined, color: Color(0xFF8888AA)),
              selectedIcon: Icon(Icons.library_music, color: Color(0xFF7B2FBE)),
              label: 'Bibliothèque',
            ),
            NavigationDestination(
              icon: Icon(Icons.queue_music_outlined, color: Color(0xFF8888AA)),
              selectedIcon: Icon(Icons.queue_music, color: Color(0xFF7B2FBE)),
              label: 'Playlists',
            ),
          ],
        ),
      ),
    );
  }
}
