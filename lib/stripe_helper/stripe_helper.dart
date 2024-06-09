// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeHelper {
  static final StripeHelper instance = StripeHelper();

  Map<String, dynamic>? paymentIntent;

  Future<bool> makePayment(String amount) async {
    try {
      // Step 1: Create a payment intent
      paymentIntent = await createPaymentIntent("1000", 'USD');

      // Step 2: Initialize Payment Sheet
      await initializePaymentSheet();

      // Step 3: Display Payment Sheet
      await displayPaymentSheet();

      return true;
    } catch (error) {
      showMessage(error
          .toString()); // Assuming showMessage is a function you've defined elsewhere
      return false;
    }
  }

  Future<void> initializePaymentSheet() async {
    try {
      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "USD",
        testEnv: true,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Electronics Hub',
          googlePay: gpay,
        ),
      );
    } catch (error) {
      throw Exception('Failed to initialize Payment Sheet');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (error) {
      throw Exception('Failed to display Payment Sheet');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };
      final authorizationkey = dotenv.env['AUTHORIZATION_KEY'] ?? "";

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': authorizationkey, // in .env file ....
        },
        body: body,
      );

      return json.decode(response.body);
    } catch (error) {
      throw Exception('Failed to create payment intent');
    }
  }

  void showMessage(String message) {
    // Implement your showMessage method here
  }
}
