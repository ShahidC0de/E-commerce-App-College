// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/constants/routes.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/change_password.dart';
import 'package:tech_trove_shop/screens/edit_profile.dart';
import 'package:tech_trove_shop/screens/favourate_screen.dart';
import 'package:tech_trove_shop/screens/order_screen.dart';
import 'package:tech_trove_shop/screens/welcome.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlueAccent,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Profile Section
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProfileAvatar(appProvider),
                  const SizedBox(height: 10),
                  _buildProfileName(appProvider),
                  _buildProfileEmail(appProvider),
                ],
              ),
            ),
            // Account Menu
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildCustomListTile(
                      icon: Icons.shopping_bag_outlined,
                      title: "Orders",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrderScreen()));
                      },
                    ),
                    _buildCustomListTile(
                      icon: Icons.favorite_outline,
                      title: "Favourites",
                      onTap: () {
                        Routes().push(const FavourateScreen(), context);
                      },
                    ),
                    _buildCustomListTile(
                      icon: Icons.info_outline,
                      title: "About Us",
                      onTap: () {},
                    ),
                    _buildCustomListTile(
                      icon: Icons.support,
                      title: "Support",
                      onTap: () {},
                    ),
                    _buildCustomListTile(
                      icon: Icons.security_outlined,
                      title: "Change Password",
                      onTap: () {
                        Routes().push(const ChangePassword(), context);
                      },
                    ),
                    _buildCustomListTile(
                      icon: Icons.logout_outlined,
                      title: "Logout",
                      onTap: () {
                        setState(() {
                          FirebaseAuthHelper.instance.signOut();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(AppProvider appProvider) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          appProvider.getUserInformation.image == null
              ? const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
                )
              : CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      NetworkImage(appProvider.getUserInformation.image!),
                ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CupertinoButton(
              child: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                Routes().push(const EditProfile(), context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileName(AppProvider appProvider) {
    return Text(
      appProvider.getUserInformation.name,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildProfileEmail(AppProvider appProvider) {
    return Text(
      appProvider.getUserInformation.email,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildCustomListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.lightBlueAccent,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: onTap,
        ),
      ),
    );
  }
}
