import 'package:flutter/material.dart';
import 'package:retake_app/auth/auth_request.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/menu/main_menu.dart';
import 'package:retake_app/store%20endpoints/prices.dart';

import '../party endpoints/get_party.dart';


class FooterMenuBar extends StatefulWidget{
  const FooterMenuBar({super.key});

  @override
  _FooterMenuBarState createState() => _FooterMenuBarState();
}

class _FooterMenuBarState extends State<FooterMenuBar> {
 
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final List<Widget> _telas = [
    const AuthRequestButton(),
    const MainMenu(),
    const Prices(),
  ];
  int _indiceAtual = 1;

  void onTabTapped(int index){
    index == 1 ?
     _drawerKey.currentState?.openEndDrawer(): setState(() {
      _indiceAtual = 0;
    });
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: globalScreenIndicator? _telas[2] : _telas[_indiceAtual],
      key: _drawerKey,
      endDrawer: const MenuDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _indiceAtual,
        onTap: onTabTapped,
        backgroundColor: Color.fromARGB(255, 31, 33, 38),
        unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
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


