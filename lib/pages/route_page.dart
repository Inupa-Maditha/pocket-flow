import 'package:flutter/material.dart';
import 'package:pocket_flow/pages/add_transaction_page.dart';
import 'package:pocket_flow/pages/home_page.dart';
import 'package:pocket_flow/pages/records_page.dart';
import 'package:pocket_flow/pages/settings_page.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _currentIndex = 0;
  final List<Widget> _page = [HomePage(), AddTransactionPage(), RecordsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pocket Flow'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _page[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        enableFeedback: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'New'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz_sharp), label: 'Records'),
        ],
      ),
    );
  }
}
