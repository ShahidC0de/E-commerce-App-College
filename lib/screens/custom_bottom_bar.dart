import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tech_trove_shop/screens/account_screen.dart';
import 'package:tech_trove_shop/screens/cart_screen.dart';
import 'package:tech_trove_shop/screens/favourate_screen.dart';
import 'package:tech_trove_shop/screens/home.dart';

class CustomBottomBar extends StatefulWidget {
  // ignore: use_super_parameters
  const CustomBottomBar({
    final Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final PersistentTabController _controller = PersistentTabController();
  // ignore: prefer_final_fields

  List<Widget> _buildScreens() => [
        const HomePage(),
        const CartScreen(),
        const FavourateScreen(),
        const AccountScreen(),

        // MainScreen(
        //   menuScreenContext: widget.menuScreenContext,
        //   hideStatus: _hideNavBar,
        //   onScreenHideButtonPressed: () {
        //     setState(() {
        //       _hideNavBar = !_hideNavBar;
        //     });
        //   },
        // ),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
            icon: const Icon(Icons.home),
            title: "Home",
            activeColorPrimary: Colors.lightBlueAccent,
            inactiveColorPrimary: Colors.white,
            inactiveColorSecondary: Colors.purple),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          title: "Cart",
          activeColorPrimary: Colors.lightBlueAccent,
          inactiveColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite_outline),
          title: "Favourates",
          activeColorPrimary: Colors.lightBlueAccent,
          inactiveColorPrimary: Colors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: "Account",
          activeColorPrimary: Colors.lightBlueAccent,
          inactiveColorPrimary: Colors.white,
        ),
      ];

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          resizeToAvoidBottomInset: true,
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          bottomScreenMargin: 0,

          decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),

          navBarStyle:
              NavBarStyle.style1, // Choose the nav bar style with this property
        ),
      );
}
