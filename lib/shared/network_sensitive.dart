import 'package:flutter/material.dart';
import 'package:magicards/services/services.dart';
import '../enums/connectivity_status.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;

  NetworkSensitive({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if (connectionStatus == ConnectivityStatus.WiFi ||
        connectionStatus == ConnectivityStatus.Cellular) {
      return child;
    } else {
      return NoConnectionScreen();
    }
  }
}
