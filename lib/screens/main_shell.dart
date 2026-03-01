import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/bubble_background.dart';
import '../widgets/mini_player.dart';
import 'home_tab.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'playlists_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    HomeTab(),
    SearchScreen(),
    LibraryScreen(),
    PlaylistsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: AnimatedBubbleBackground(
        child: Stack(
          children: [
            // Main content
            _screens[_index],
            // Mini player + nav bar overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MiniPlayer(),
                  _buildNavBar(bottomPad),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(double bottomPad) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: const Color(0xFF0A0A0A).withOpacity(0.75),
          padding: EdgeInsets.only(
              top: 8, bottom: bottomPad + 8, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_filled, Icons.home_outlined, 'Accueil'),
              _navItem(1, Icons.search, Icons.search_outlined, 'Recherche'),
              _navItem(2, Icons.library_music, Icons.library_music_outlined, 'Biblio'),
              _navItem(3, Icons.queue_music, Icons.queue_music_outlined, 'Playlists'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int idx, IconData active, IconData inactive, String label) {
    final selected = _index == idx;
    return GestureDetector(
      onTap: () => setState(() => _index = idx),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? const Color(0xFF1DB954).withOpacity(0.12)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? active : inactive,
              color: selected ? const Color(0xFF1DB954) : Colors.white.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFF1DB954) : Colors.white.withOpacity(0.4),
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
