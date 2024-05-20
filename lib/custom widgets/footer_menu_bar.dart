import 'package:flutter/material.dart';
import 'package:retake_app/auth/auth_request.dart';
import 'package:retake_app/match_endpoints/match_details.dart';
import 'package:retake_app/menu/main_menu.dart';
import 'package:retake_app/party%20endpoints/get_party.dart';
import 'package:retake_app/store%20endpoints/prices.dart';

class FooterMenuBar extends StatefulWidget {
  const FooterMenuBar({super.key});

  @override
  _FooterMenuBarState createState() => _FooterMenuBarState();
}

class _FooterMenuBarState extends State<FooterMenuBar> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final clear = GetParty();
  final List<Widget> _telas = [
    const AuthRequestButton(),
    const MainMenu(),
    const Prices(),
     MatchDetails()
  ];
  int _indiceAtual = 1;

  void onTabTapped(int index) {
    
    index == 1
        ? _drawerKey.currentState?.openEndDrawer()
        : setState(() {
            globalScreenIndicator = 0;
            clear.clear();
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[globalScreenIndicator],
      key: _drawerKey,
      endDrawer: const MenuDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _indiceAtual,
        onTap: onTabTapped,
        backgroundColor: const Color.fromARGB(255, 31, 33, 38),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
