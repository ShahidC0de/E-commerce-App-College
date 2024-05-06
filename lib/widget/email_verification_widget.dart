import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tech_trove_shop/Firebase/firebase_auth.dart';
import 'package:tech_trove_shop/main.dart';

class EmailSendVerificationDialog extends StatefulWidget {
  const EmailSendVerificationDialog({super.key});

  @override
  State<EmailSendVerificationDialog> createState() =>
      _EmailSendVerificationDialogState();
}

class _EmailSendVerificationDialogState
    extends State<EmailSendVerificationDialog> {
  late Timer _timer;
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && user.emailVerified) {
        const MyApp();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _timer.cancel();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Email Verification ${remainingSeconds.toString()}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('After verification please restart the app'),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuthHelper.instance.verifyTheUser();
                _timer.cancel();
                remainingSeconds == 60;
                startTimer();
                setState(() {});
              },
              child: Text(
                remainingSeconds != 0
                    ? remainingSeconds.toString()
                    : 'Send verification',
              ))
        ],
      ),
    );
  }
}
