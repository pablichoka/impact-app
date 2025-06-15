import 'package:flutter/material.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/home/bookings/bookings.dart';
import 'package:impact/screens/home/dashboard/dashboard.dart';
import 'package:impact/screens/home/profile/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final currentUser = User(
    name: 'Juan',
    lastName: 'Pérez',
    username: 'juanperez',
    email: 'juan.perez@example.com',
    joinDate: DateTime(2023, 1, 15),
    isPremium: true,
    birthDate: DateTime(1990, 5, 20),
  );

  late final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    BookingsScreen(),
    ProfileScreen(user: currentUser),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.secondary,
        unselectedItemColor: theme.colorScheme.secondary.withValues(alpha: 0.6),
        onTap: _onItemTapped,
        backgroundColor: theme.colorScheme.surface,
      ),
    );
  }
}
