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
import 'firebase_options.dart';

import 'package:tech_trove_shop/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // firebase initialization is important before using firebase services.
  // mainly it can be done in main function.
  Stripe.publishableKey =
      'pk_test_51O8mRyJdUwUvJDm6x2CmN6xNYUtgPXnMbVh8x93rWdJuBdYBMrZj2V2gZRu5HaKV8Hp5n9dVcpE8lsF2a9VP7Z7V0072mReMoQ';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
