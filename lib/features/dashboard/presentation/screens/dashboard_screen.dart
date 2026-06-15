import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../savings/presentation/screens/savings_screen.dart';
import '../../../goals/presentation/screens/goals_screen.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SavingsScreen(),
    const GoalsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true, // Allows body content to flow under the floating nav bar
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: NavigationBar(
                height: 72,
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                backgroundColor: colorScheme.surface.withValues(alpha: 0.7),
                elevation: 0,
                indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(LucideIcons.layoutDashboard),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(LucideIcons.piggyBank),
                    label: 'Savings',
                  ),
                  NavigationDestination(icon: Icon(LucideIcons.target), label: 'Goals'),
                  NavigationDestination(icon: Icon(LucideIcons.user), label: 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
