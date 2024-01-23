import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';
import 'package:tech_trove_shop/screens/custom_bottom_bar.dart';
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
                if (snapshot.hasData) {
                  return const CustomBottomBar();
                } else {
                  return const Welcome();
                }
              })),
    );
  }
}
