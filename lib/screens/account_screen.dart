import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/change_password.dart';
import 'package:tech_trove_shop/screens/edit_profile.dart';
import 'package:tech_trove_shop/screens/favourate_screen.dart';
import 'package:tech_trove_shop/screens/order_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "                    Account",
          style: TextStyle(
              color: Colors.lightBlueAccent, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                appProvider.getUserInformation.image == null
                    ? const Icon(
                        Icons.person,
                        color: Colors.lightBlueAccent,
                        size: 120,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(appProvider.getUserInformation.image!),
                        radius: 60,
                      ),
                Text(
                  appProvider.getUserInformation.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                Text(
                  appProvider.getUserInformation.email,
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                      onPressed: () {
                        Routes().push(const EditProfile(), context);
                      },
                      child: const Text("Edit Profile")),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Routes().push(const OrderScreen(), context);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (ctx) => const OrderScreen(),
                    //   ),
                    // );
                  },
                  leading: const Icon(
                    Icons.shopping_bag,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    "Orders",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Routes().push(const FavourateScreen(), context);
                    // Routes().push(const FavourateScreen(), context);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (ctx) => const FavourateScreen(),
                    //   ),
                    // );
                  },
                  leading: const Icon(
                    Icons.favorite,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    "Favourates",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.info,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    "About us",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.support,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    "Support",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Routes().push(const ChangePassword(), context);
                  },
                  leading: const Icon(
                    Icons.change_circle,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    FirebaseAuthHelper.instance.signOut();
                    setState(() {});
                  },
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
