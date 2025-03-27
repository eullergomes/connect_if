import 'package:connect_if/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect_if/features/home/presentation/pages/feed_screen.dart';
import 'package:connect_if/features/profile/presentation/pages/profile_page.dart';
import 'package:connect_if/features/search/pages/search_page.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final String uid;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().currentUser;
    uid = user!.uid;
    _screens = [
      const FeedScreen(),
      const SearchPage(),
      const SearchPage(),
      ProfilePage(uid: uid),
    ];
  }

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
              colorFilter: ColorFilter.mode(
                _currentIndex == index
                    ? AppThemeCustom.green400
                    : AppThemeCustom.black,
                BlendMode.srcIn,
              ),
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