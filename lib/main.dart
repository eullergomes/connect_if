import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connect_if/screens/feed_screen.dart';
import 'package:connect_if/screens/conversations_screen.dart';
import 'package:connect_if/screens/create_post_screen.dart';
import 'package:connect_if/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomNavigationBar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const ChatScreen(),
    const CreatePostScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = ['Feed', 'Conversas', 'Criar', 'Perfil'];

  final List<String> _icons = [
    'assets/images/feed_icon_black.svg',
    'assets/images/conversations_icon.svg',
    'assets/images/create_icon.svg',
    'assets/images/profile_icon.svg',
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize( 
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar( 
          elevation: 0,
        ), 
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: List.generate(_titles.length, (index) {
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _icons[index],
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode( _currentIndex == index ? AppThemeCustom.green400 : AppThemeCustom.black, BlendMode.srcIn, ),
            ),
            label: _titles[index],
          );
        }),
        selectedItemColor: AppThemeCustom.green400,
        unselectedItemColor: AppThemeCustom.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}
