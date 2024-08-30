import 'package:commerce_app/bloc/auth.bloc.dart';
import 'package:commerce_app/bloc/basket.bloc.dart';
import 'package:commerce_app/bloc/order.bloc.dart';
import 'package:commerce_app/comp/custom_button.comp.dart';
import 'package:commerce_app/comp/payment_success.comp.dart';
import 'package:commerce_app/event/basket.event.dart';
import 'package:commerce_app/event/order.event.dart';
import 'package:commerce_app/model/basket.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() {
    return _PaymentScreenState();
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  //결제위젯: 결제에 필요한 모든 요소를 포함 (결제수단 선택, 결제 요청, 약관 동의)
  late PaymentWidget _paymentWidget;
  PaymentMethodWidgetControl? _paymentMethodWidgetControl;
  AgreementWidgetControl? _agreementWidgetControl;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state;
    final userId = user.user!.id;

    // 결제 위젯 초기화
    _paymentWidget = PaymentWidget(
      clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
      customerKey: userId,
    );

    // 결제 방법 UI
    _paymentWidget
        .renderPaymentMethods(
            selector: 'methods',
            amount: Amount(value: 300, currency: Currency.KRW, country: "KR"),
            options: RenderPaymentMethodsOptions(variantKey: "DEFAULT"))
        .then((control) {
      _paymentMethodWidgetControl = control;
    });

    // 약관 동의 UI
    _paymentWidget.renderAgreement(selector: 'agreement').then((control) {
      _agreementWidgetControl = control;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<BasketBloc>().state;

    if (state.basket.isNotEmpty) {
      final nonNullableBasket = state.basket
          .where((item) => item != null)
          .map((item) => item!)
          .toList();

      return Scaffold(
          body: SafeArea(
              child: Column(children: [
        Expanded(
            child: ListView(children: [
          //PaymentWidget에 PaymentMethodWidget을 연결
          PaymentMethodWidget(
            paymentWidget: _paymentWidget,
            selector: 'methods',
          ),
          // PaymentWidget에 AgreementWidget을 연결
          AgreementWidget(paymentWidget: _paymentWidget, selector: 'agreement'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: CustomButton(
                onPressed: () async {
                  final orderId = Uuid().v4();
                  //Order db
                  context.read<OrderBloc>().add(CreateOrder(
                        basket: nonNullableBasket,
                        orderId: orderId,
                      ));

                  final paymentResult = await _paymentWidget.requestPayment(
                    paymentInfo: PaymentInfo(
                      orderId: orderId,
                      orderName:
                          '${nonNullableBasket.first.name}외 ${nonNullableBasket.fold(0, (p, item) => p + item.quantity)}개',
                    ),
                  );

                  if (paymentResult.success != null) {
                    //payment status = success
                    context.read<OrderBloc>().add(ChangePaymentStatus(
                          orderId: orderId,
                        ));

                    context.read<BasketBloc>().add(RemoveMultipleBasket(
                        basketIds:
                            nonNullableBasket.map((e) => e.id).toList()));

                    // 결제 성공 처리
                    showOrderSuccessDialog(
                      context,
                    );
                  } else if (paymentResult.fail != null) {
                    // 결제 실패 처리
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('결제 실패'),
                          content: Text('결제에 실패했습니다. 다시 시도해주세요.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                //전 화면으로 이동
                                Navigator.of(context).pop();
                              },
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                text: '결제하기'),
          ),
        ]))
      ])));
    }
    return Container();
  }
}
