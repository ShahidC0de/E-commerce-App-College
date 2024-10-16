// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/custom_bottom_bar.dart';
import 'package:tech_trove_shop/screens/signup.dart';
import 'package:tech_trove_shop/widget/email_verification_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:tech_trove_shop/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // firebase initialization is important before using firebase services.
  // mainly it can be done in main function.
  await dotenv.load(fileName: '.env');
  final stripeKey = dotenv.env['STRIPE_KEY'] ??
      ""; // create .env file in the root folder of project and place your api_key.
  Stripe.publishableKey = stripeKey; // also stripe_key in .env file.
  try {
    final api_key = dotenv.env["ANDROID_API_KEY"] ?? "";
    //firebase was returning a null value, so this helped to solve the problem;
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: FirebaseOptions(
                apiKey: api_key,
                appId: "1:973121984053:android:eb57c772b96d8a919b437c",
                messagingSenderId: "973121984053",
                projectId: "tech-trove-shop-3ea50"),
          )
        : await Firebase.initializeApp();
  } catch (_) {}

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tech Trove',
          // if the user exits the app and open it again, the user dont have to login again.
          home: StreamBuilder(
              stream: FirebaseAuthHelper.instance.getAuthChange,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Column(
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.lightBlueAccent,
                          ),
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.hasData) {
                  User? currentUser = FirebaseAuth.instance.currentUser;

                  if (currentUser!.emailVerified) {
                    return const CustomBottomBar();
                  } else if (snapshot.hasData &&
                      currentUser.emailVerified == false) {
                    return Scaffold(
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: EmailSendVerificationDialog(),
                          ),
                          BottomAppBar(
                            child: TextButton(
                              onPressed: () async {
                                await currentUser.delete();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return const SignUp();
                                }));
                              },
                              child: const Text('Sign Up with another email?'),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Welcome();
                  }
                } else {
                  return const Welcome();
                }
              })),
    );
  }
}
