// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tech_trove_shop/screens/account_screen.dart';
import 'package:tech_trove_shop/screens/cart_screen.dart';
import 'package:tech_trove_shop/screens/favourate_screen.dart';
import 'package:tech_trove_shop/screens/home.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final PersistentTabController _controller = PersistentTabController();

  List<Widget> _buildScreens() => [
        const HomePage(),
        const CartScreen(),
        const FavourateScreen(),
        const AccountScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          activeColorPrimary: Colors.lightBlueAccent,
          inactiveColorPrimary: Colors.white,
          inactiveColorSecondary: Colors.purple,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          activeColorPrimary: Colors.lightBlueAccent,
          inactiveColorPrimary: Colors.white,
          inactiveColorSecondary: Colors.purpleAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite_outline),
          activeColorPrimary: Colors.lightBlueAccent,
          inactiveColorPrimary: Colors.white,
          inactiveColorSecondary: Colors.redAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          activeColorPrimary: Colors.lightBlueAccent,
          inactiveColorPrimary: Colors.white,
          inactiveColorSecondary: Colors.orangeAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        resizeToAvoidBottomInset: true,
        backgroundColor:
            Colors.transparent, // Transparent background for gradient effect
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(15.0),
          colorBehindNavBar: Colors.white, // Color behind the gradient
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        navBarStyle: NavBarStyle.style6, // Choose the modern style
      ),
    );
  }
}
