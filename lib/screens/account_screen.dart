import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/change_password.dart';
import 'package:tech_trove_shop/screens/edit_profile.dart';
import 'package:tech_trove_shop/screens/favourate_screen.dart';
import 'package:tech_trove_shop/screens/order_screen.dart';
import 'package:tech_trove_shop/widget/list_tile_item.dart';

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
        centerTitle: true,
        title: const Text(
          "Account",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                        color: Colors.grey,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  appProvider.getUserInformation.email,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      onPressed: () {
                        Routes().push(const EditProfile(), context);
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                CustomListTile(
                  leadingIcon: const Icon(Icons.shopping_bag_outlined),
                  title: "Orders",
                  onTap: () {
                    Routes().push(const OrderScreen(), context);
                  },
                ),
                CustomListTile(
                  leadingIcon: const Icon(
                    Icons.favorite_outline,
                  ),
                  title: 'Favourates',
                  onTap: () {
                    Routes().push(const FavourateScreen(), context);
                  },
                ),
                CustomListTile(
                  leadingIcon: const Icon(Icons.info_outline),
                  title: 'About us..',
                  onTap: () {},
                ),
                CustomListTile(
                  leadingIcon: const Icon(
                    Icons.support,
                  ),
                  title: 'Support',
                  onTap: () {},
                ),
                CustomListTile(
                  leadingIcon: const Icon(
                    Icons.security_outlined,
                  ),
                  title: 'Change Password',
                  onTap: () {
                    Routes().push(const ChangePassword(), context);
                  },
                ),
                CustomListTile(
                  leadingIcon: const Icon(
                    Icons.logout_outlined,
                  ),
                  title: 'Logout',
                  onTap: () {
                    FirebaseAuthHelper.instance.signOut();
                  },
                ),
                const SizedBox(
                  height: 12.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
