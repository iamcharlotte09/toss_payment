import 'package:commerce_app/bloc/order.bloc.dart';
import 'package:commerce_app/comp/custom_button.comp.dart';
import 'package:commerce_app/const/colors.dart';
import 'package:commerce_app/event/order.event.dart';
import 'package:commerce_app/model/basket.model.dart';
import 'package:commerce_app/screen/orders.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showOrderSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PaymentSuccessDialog();
    },
  );
}

class PaymentSuccessDialog extends StatelessWidget {
  PaymentSuccessDialog({Key? key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ShoppingCardIcon(),
            const SizedBox(height: 16),
            _Middle(),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                  (route) => false,
                );
              },
              text: '내 주문 보러가기',
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Middle extends StatelessWidget {
  const _Middle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '결제 완료!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '성공적으로 결제를 완료했습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _ShoppingCardIcon extends StatelessWidget {
  const _ShoppingCardIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.shopping_cart,
        color: Colors.green,
        size: 64,
      ),
    );
  }
}
