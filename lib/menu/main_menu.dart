import 'package:flutter/material.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/custom%20widgets/footer_menu_bar.dart';
import 'package:retake_app/party%20endpoints/change_queue.dart';
import 'package:retake_app/party%20endpoints/get_party.dart';
import 'package:retake_app/party%20endpoints/start_queue_game.dart';
import 'package:retake_app/store%20endpoints/prices.dart';

bool globalScreenIndicator = false;
/**
 * WIdget usado para as rotas do app.
 */
class MainMenu extends StatelessWidget {
const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Retake',
      initialRoute: '/',
      routes: {
        '/': (context) =>
            GameOptions(), //globalPuuid == "" ? AuthRequestButton() :
        '/queueGame': (context) => const StartQueueGameButton(),
        '/teste': (context) => const MultiFactorAuthButton(),
      },
    );

    //bottomNavigationBar: FooterMenuBar(scaffoldKey: _scaffoldKey)
  }
}

/**
 * Widget com as opções de jogo
 */
class GameOptions extends StatelessWidget {
   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ChangeQueue changeQueue = ChangeQueue();
   List<String> options = [
    'SEM CLASSIFICAÇÃO',
    'COMPETITIVO',
    'FRENÉTICO',
    'DISPUTA DE SPIKE',
    'MATA-MATA',
    'DISPARADA',
    'MATA-MATA EM EQUIPE',
  ];
   List<String> queueOptions = [
    "unrated",
    "competitive",
    "swiftplay",
    "spikerush",
    "deathmatch",
    "ggteam",
    "hurm"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/market_background.jpg'),
                fit: BoxFit.cover)
                ),
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                options[index],
                style: const TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'TungstenThin',
                    color: Color.fromARGB(255, 30, 233, 175),
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                changeQueue.changeQueue(queueOptions[index]);
                Navigator.pushReplacement(context, 
                MaterialPageRoute(builder: (context) => const StartQueueGameButton()));
              },
            );
          },
        ),
      ),
    );
  }
}

/**
 * Widget do menuDrawer na opção "Menu" no FooterMenuBar
 */
class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => MenuDrawerState();
}

/**
 * Widget do menuDrawer na opção "Menu" no FooterMenuBar
 */
class MenuDrawerState extends State<MenuDrawer> {
  int _selectedIndex = 0;
  final getParty = GetParty();
  Prices clearPrices = Prices();
  final displayIcon = GetParty().getCardDisplayIcon();
  static const TextStyle _menuStyle = TextStyle(
    color: Color.fromARGB(255, 30, 233, 175),
    fontFamily: 'TungstenThin',
    fontSize: 20,
    fontWeight: FontWeight.w900,
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Theme(
      data: Theme.of(context).copyWith(
        canvasColor: const Color.fromARGB(255, 34, 60, 9),
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255,9,38,60)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          NetworkImage(getParty.getCardDisplayIcon())),
                  Text(
                    globalNickName,
                    style: _menuStyle,
                  )
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'JOGAR',
                style: _menuStyle,
              ),
              selected: _selectedIndex == 0,
              onTap: () {
                //getParty.clear(); // Aparentemente as informações dos membros da sala não estão sendo duplicadas.
                globalScreenIndicator = false;
                _onItemTapped(_selectedIndex);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FooterMenuBar()));
              },
            ),
            ListTile(
              title: const Text(
                'LOJA',
                style: _menuStyle,
              ),
              selected: _selectedIndex == 1,
              onTap: () {
                clearPrices.clear();
                globalScreenIndicator = true;
                _onItemTapped(_selectedIndex);
                Navigator.pop(context);
              Navigator.pushReplacement(context, 
                MaterialPageRoute(builder: (context) => const FooterMenuBar()));
              },
            )
          ],
        ),
      ),
    )
    );
  }
}
