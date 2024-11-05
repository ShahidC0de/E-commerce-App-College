import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/custom_bottom_bar.dart';
import 'package:tech_trove_shop/screens/signup.dart';
import 'package:tech_trove_shop/widget/email_verification_widget.dart';
import 'package:tech_trove_shop/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final stripeKey = dotenv.env['STRIPE_PUBLISHIBLE_KEY'] ?? "";
  Stripe.publishableKey = stripeKey;

  try {
    final apiKey = dotenv.env["ANDROID_API_KEY"] ?? "";

    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: FirebaseOptions(
              apiKey: apiKey,
              appId: "1:973121984053:android:eb57c772b96d8a919b437c",
              messagingSenderId: "973121984053",
              projectId: "tech-trove-shop-3ea50",
              storageBucket: "tech-trove-shop-3ea50.appspot.com",
            ),
          )
        : await Firebase
            .initializeApp(); // Ensure you have iOS config in FirebaseOptions for iOS

    print("Firebase initialized successfully.");
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tech Trove',
          home: StreamBuilder(
              stream: FirebaseAuthHelper.instance.getAuthChange,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                          color: Colors.lightBlueAccent),
                    ),
                  );
                }

                User? currentUser = FirebaseAuth.instance.currentUser;

                if (snapshot.hasData && currentUser != null) {
                  if (currentUser.emailVerified) {
                    return const CustomBottomBar();
                  } else {
                    return Scaffold(
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const EmailSendVerificationDialog(),
                          BottomAppBar(
                            child: TextButton(
                              onPressed: () async {
                                await currentUser.delete();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()));
                              },
                              child: const Text('Sign Up with another email?'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return const Welcome();
                }
              })),
    );
  }
}
