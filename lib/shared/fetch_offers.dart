import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magicards/api/purchase_api.dart';
import 'package:magicards/shared/paywall.dart';

Future fetchOffers(BuildContext context, User user) async {
  final offerings = await PurchaseApi.fetchOffers();

  if (offerings.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Подписки не найдены"),
      ),
    );
  } else {
    final packages = offerings
        .map((offer) => offer.availablePackages)
        .expand((pair) => pair)
        .toList();

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Paywall(
          packages: packages,
          onCLickedPackage: (package) async {
            if (user != null) {
              await PurchaseApi.purchasePackage(context, package);
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/login',
                arguments: {"prevScreen": "paywall"},
              );
            }
          },
        );
      },
    );
  }
}
