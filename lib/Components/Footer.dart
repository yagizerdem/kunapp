import 'package:app/Providers/MainScreenProvider.dart';
import 'package:app/pages/ChatPage.dart';
import 'package:app/pages/HomePage.dart';
import 'package:app/pages/ProfilePage.dart';
import 'package:app/pages/SearchPage.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget? activeScreen = null;
    if (index == 0)
      activeScreen = HomePage();
    else if (index == 1)
      activeScreen = SearchPage();
    else if (index == 2)
      activeScreen = ChatPage();
    else if (index == 3) activeScreen = ProfilePage();

    final provider = Provider.of<MainScreenProvider>(context, listen: false);

    if (activeScreen != null) {
      provider.setMainScreen(activeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.orange,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: Colors.orange,
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
            color: Colors.orange,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: Colors.orange,
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.primarySwatch.shade500,
      onTap: _onItemTapped,
    );
  }
}
