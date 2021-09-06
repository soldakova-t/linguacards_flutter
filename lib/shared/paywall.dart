import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:magicards/services/services.dart';
import 'package:magicards/shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Paywall extends StatefulWidget {
  final List<Package> packages;
  final ValueChanged<Package> onCLickedPackage;

  Paywall({Key key, this.packages, this.onCLickedPackage}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    bool showPlusOffer = false;
    StringsFB stringsFB = Provider.of<StringsFB>(context);
    if (stringsFB != null) {
      showPlusOffer = true;
    }

    return Container(
      height: 440,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child:
                        SvgPicture.asset('assets/icons/logo_without_sign.svg'),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: convertHeightFrom360(context, 360, 22),
                    width: convertWidthFrom360(context, 74),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF656565)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(convertWidthFrom360(context, 6)),
                      ),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Text("плюс", style: myAppBarPremiumLabelStyle),
                    ),
                  ),
                ],
              ),
            ),
            showPlusOffer
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      stringsFB.plusOffer,
                      style: myPlusOfferLabelStyle,
                    ),
                  )
                : Container(),
            SizedBox(height: 16.0),
            buildPackages(),
          ],
        ),
      ),
    );
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

    String currentPrice = product.priceString;
    String oldPrice = "";
    String period = "";

    Sale sale = Provider.of<Sale>(context);
    if (product.identifier == "lingvicards_1200_1y") {
      if (sale != null) {
        oldPrice = sale.priceBeforeSale1y;
      }
      period = "в год";
    }
    if (product.identifier == "lingvicards_200_1m") {
      if (sale != null) {
        oldPrice = sale.priceBeforeSale1m;
      }
      period = "в месяц";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => widget.onCLickedPackage(package),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD8D8D8)),
            borderRadius: BorderRadius.all(
              Radius.circular(convertWidthFrom360(context, 10)),
            ),
          ),
          height: 115.0,
          child: Stack(
            children: [
              //Text(product.title.split(" (Lingvicards)")[0]),
              Positioned(
                top: 22.0,
                left: 27.0,
                child: Text(
                  currentPrice.split(",00")[0] + " ₽",
                  style: myCurrentPricePaywall,
                ),
              ),
              Positioned(
                top: 49.0,
                left: 27.0,
                child: Text(
                  oldPrice + " ₽",
                  style: myOldPricePaywall,
                ),
              ),
              Positioned(
                top: 30.0,
                left: 95.0,
                child: Text(
                  period,
                  style: myPeriodPaywall,
                ),
              ),
              (product.identifier == "lingvicards_1200_1y")
                  ? Positioned(
                      top: 20.0,
                      right: 20.0,
                      child: Container(
                        height: convertHeightFrom360(context, 360, 22),
                        width: convertWidthFrom360(context, 74),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(convertWidthFrom360(context, 6)),
                          ),
                          color: MyColors.logoPinkColor,
                        ),
                        child: Center(
                          child: Text("выгодно", style: myProfitablyLabelStyle),
                        ),
                      ),
                    )
                  : Container(),
              (sale != null)
                  ? Positioned(
                      top: 74.0,
                      left: 27.0,
                      child: Text(
                        sale.message,
                        style: mySalePaywallLabelStyle,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
