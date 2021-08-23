import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Paywall extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onCLickedPackage;

  Paywall(
      {Key key,
      this.title,
      this.description,
      this.packages,
      this.onCLickedPackage})
      : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    print(widget.packages.length);
    return buildPackages();
  }

  Widget buildPackages() => ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          final package = widget.packages[index];
          return buildPackage(context, package);
        },
      );

  Widget buildPackage(BuildContext context, Package package) {
    final product = package.product;
    return GestureDetector(
      onTap: () => widget.onCLickedPackage(package),
      child: Container(
        color: Colors.amber,
        height: 50,
        child: Column(
          children: [
            Text(product.title),
          ],
        ),
      ),
    );
  }
}
