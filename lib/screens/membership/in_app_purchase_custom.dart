import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class InAppPurchaseCustom extends StatefulWidget {
  const InAppPurchaseCustom({super.key});

  @override
  State<InAppPurchaseCustom> createState() => _InAppPurchaseCustomState();
}

class _InAppPurchaseCustomState extends State<InAppPurchaseCustom> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];

  bool _isAvailable = false;

  List<ProductDetails> _products = [];
  @override
  void initState() {
    // TODO: implement initState
    // Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();

    getProducts();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
      });
      return;
    }
  }

  getProducts() async {
    const Set<String> _kIds = <String>{'normal_silver', 'normal_gold'};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
    }
    List<ProductDetails> products = response.productDetails;
    setState(() {
      _products = products;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Membership"),
      ),
      body: ListView(
        children: productWidgets(),
      ),
    );
  }

  Widget _buildRestoreButton() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _inAppPurchase.restorePurchases(),
            child: const Text('Restore purchases'),
          ),
        ],
      ),
    );
  }

  List<Widget> productWidgets() {
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    List<Widget> productWidgetList = [];
    productWidgetList.addAll(_products.map((ProductDetails productDetails) {
      final PurchaseDetails? previousPurchase = purchases[productDetails.id];
      return ListTile(
        title: Text(
          productDetails.title,
        ),
        subtitle: Text(
          productDetails.description,
        ),
        trailing: previousPurchase != null && Platform.isIOS
            ? IconButton(
                onPressed: () => confirmPriceChange(context),
                icon: const Icon(Icons.upgrade))
            : TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  late PurchaseParam purchaseParam;

                  purchaseParam = PurchaseParam(
                    productDetails: productDetails,
                  );

                  _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
                  // _inAppPurchase.completePurchase();
                },
                child: Text(productDetails.price),
              ),
      );
    }));
    productWidgetList.add(
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          printIfSubscribed();
        },
        child: const Text('Get purchases'),
      ),
    );
    productWidgetList.add(_buildRestoreButton());
    return productWidgetList;
  }

  printIfSubscribed() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((purchaseDetailsList) {}, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
      print(error.toString());
    });
    _subscription.onData((data) {
      if (data.isNotEmpty) {
        print(data[0].status);
      }
    });
  }

  bool _purchasePending = false;
  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            //unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails).then((value) {
            if (purchaseDetails.status == PurchaseStatus.purchased) {
              print(purchaseDetails.status.toString() + "--status");
              showToast("To The server");
            }
          });
        }
      }
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    showToast(purchaseDetails.productID.toString());
    // showToast("Verifying Purchase");
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    showToast("Invalid Purchase");
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    // Price changes for Android are not handled by the application, but are
    // instead handled by the Play Store. See
    // https://developer.android.com/google/play/billing/price-changes for more
    // information on price changes on Android.
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }
}
