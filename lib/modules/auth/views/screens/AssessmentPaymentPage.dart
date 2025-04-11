import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/modules/auth/models/request/CreatePayOrderReq.dart';
import 'package:health_ed_flutter/modules/auth/models/request/VerifyPayOrderReq.dart';
import 'package:health_ed_flutter/modules/auth/models/response/AllPlanResponse.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/utils/custom_snackbar.dart';

class Assessmentpaymentpage extends StatelessWidget {


  const Assessmentpaymentpage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaymentPageScreenContent(
    );
  }
}

class PaymentPageScreenContent extends StatefulWidget {

  const PaymentPageScreenContent(
      {Key? key})
      : super(key: key);

  @override
  ActivityInstructionContent createState() => ActivityInstructionContent();
}
enum PaymentResultStatus { loading, success, failure, none }

class ActivityInstructionContent
    extends State<PaymentPageScreenContent> {

  late Razorpay _razorpay;
  PaymentResultStatus paymentStatus = PaymentResultStatus.loading;
  String paymentMessage = '';
  String orderId = '';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // final createPayOrderReq = CreatePayOrderReq(planId: widget.planData.razorpayPlanId!);
    context.read<AuthBloc>().add(CreateAssessPaymentRequested());
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final verifyPayOrderReq = VerifyPayOrderReq(orderId:orderId ,paymentId:response.paymentId!,razorpaySignature:response.signature! );
    context.read<AuthBloc>().add(VerifyAssessPaymentRequested(verifyPayOrderReq: verifyPayOrderReq));
    // setState(() {
    //   paymentStatus = PaymentResultStatus.success;
    //   paymentMessage = "Payment successful! Payment ID: ${response.paymentId}";
    // });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      paymentStatus = PaymentResultStatus.failure;
      paymentMessage = "Payment failed: ${response.message}";
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      paymentStatus = PaymentResultStatus.failure;
      paymentMessage = "External wallet selected: ${response.walletName}";
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          Get.back();
          customSnackbar(state.message, ContentType.failure);
        } else if (state is CreateAssessPaymentOrderSuccess) {
          orderId = state.resAssesmentCreateOrder.data!.orderId!;
          var options = {
            'key': state.resAssesmentCreateOrder.data!.key,
            'order_id': state.resAssesmentCreateOrder.data!.orderId,
            'amount': state.resAssesmentCreateOrder.data!.amount,
            'name': 'TheDhwani',
            'description': 'Payment for product',
            'prefill': {'contact': '', 'email': ''}
          };

          try {
            _razorpay.open(options);
          } catch (e) {
            debugPrint('Error: $e');
          }
        }else if (state is VerifyPaymentOrderSuccess) {
    
          try {
               setState(() {
                paymentStatus =state.resVerifyOrder.success!? PaymentResultStatus.success:PaymentResultStatus.failure;
                paymentMessage = state.resVerifyOrder.message!;
           });
          } catch (e) {
            debugPrint('Error: $e');
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Get.back();
                          if(paymentStatus==PaymentResultStatus.success)
                          Get.back();
                        },
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Payment',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),

                // Body
                Expanded(
                  child: Center(
                    child: Builder(
                      builder: (_) {
                        switch (paymentStatus) {
                          case PaymentResultStatus.success:
                            return _buildResultCard(
                              icon: Icons.check_circle,
                              color: Colors.green,
                              title: "Payment Successful",
                              message: paymentMessage
                            );
                          case PaymentResultStatus.failure:
                            return _buildResultCard(
                              icon: Icons.cancel,
                              color: Colors.red,
                              title: "Payment Failed",
                              message: paymentMessage
                            );
                          case PaymentResultStatus.loading:
                            return CustomLoader();
                          case PaymentResultStatus.none:
                          default:
                            return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required Color color,
    required String title,
    required String message, 
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: color),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                if(paymentStatus==PaymentResultStatus.success)         
                Get.back();
              },
              child: Text("Go Back"),
            )
          ],
        ),
      ),
    );
  }
}
