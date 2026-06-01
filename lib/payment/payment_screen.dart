import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/payment/payment_success.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  String name;
  String phone;
  String email;
  String price;
  String description;
  bool isWallet;
  dynamic plan;

  PaymentScreen(this.name, this.phone, this.email, this.price, this.description,
      this.isWallet, this.plan,
      {super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  late double baseAmount;
  late double gstAmount;
  late double totalAmount;

  static const double gstRate = 0.18; // 18% GST for matrimony/online services

  @override
  void initState() {
    super.initState();

    // Calculate GST
    baseAmount = double.parse(widget.price);
    gstAmount = baseAmount * gstRate;
    totalAmount = baseAmount + gstAmount;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);

    // Show tax breakdown dialog before opening Razorpay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTaxBreakdownAndPay();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  /// Show tax breakdown to user before proceeding to payment
  void _showTaxBreakdownAndPay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Payment Summary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _breakdownRow("Plan Amount", "₹${baseAmount.toStringAsFixed(2)}"),
            _breakdownRow("GST (18%)", "+ ₹${gstAmount.toStringAsFixed(2)}"),
            const Divider(thickness: 1),
            _breakdownRow("Total Payable", "₹${totalAmount.toStringAsFixed(2)}",
                bold: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // go back if user cancels
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _openRazorpay();
            },
            child: const Text("Proceed to Pay"),
          ),
        ],
      ),
    );
  }

  /// Open Razorpay with GST-inclusive total amount
  void _openRazorpay() {
    var options = {
      'key': 'rzp_live_SvapvIoK4xgEcS',
      'amount': (totalAmount * 100).toInt(), // amount in paise (integer)
      'description': widget.description,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': widget.phone, 'email': widget.email},
      'external': {
        'wallets': ['paytm']
      },
      // Tax breakdown stored in notes for records/reconciliation
      'notes': {
        'base_amount': baseAmount.toStringAsFixed(2),
        'gst_18_percent': gstAmount.toStringAsFixed(2),
        'total_with_gst': totalAmount.toStringAsFixed(2),
      }
    };

    _razorpay.open(options);
  }

  /// Row widget for breakdown display
  Widget _breakdownRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => PaymentSuccess(
                response,
                totalAmount.toStringAsFixed(2), // total with GST
                widget.name,
                widget.isWallet,
                widget.plan)));
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
