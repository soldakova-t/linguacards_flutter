import 'package:flutter/material.dart';
import 'package:magicards/enums/entitlement.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatProvider with ChangeNotifier {
  RevenueCatProvider() {
    init();
  }

  Entitlement _entitlement = Entitlement.free;
  Entitlement get entitlement => _entitlement;

  Future init() async {
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      updatePurchaseStatus();
    });
  }

  Future updatePurchaseStatus() async {
    final purchaserInfo = await Purchases.getPurchaserInfo();
    final entitlements = purchaserInfo.entitlements.active.values.toList();

    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.premium;

    notifyListeners();
  }
}
