import 'package:commerce_app/bloc/basket.bloc.dart';
import 'package:commerce_app/bloc/order.bloc.dart';
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
  final List<BasketModel> basket;

  const PaymentScreen({required this.basket, super.key});

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

    // 결제 위젯 초기화
    _paymentWidget = PaymentWidget(
      clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
      customerKey: "198d0f52-1961-4fb6-ba4a-49a404affd03",
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
        ElevatedButton(
            onPressed: () async {
              final orderId = Uuid().v4();
              //Order db
              context.read<OrderBloc>().add(CreateOrder(
                    basket: widget.basket,
                    orderId: orderId,
                  ));

              final paymentResult = await _paymentWidget.requestPayment(
                paymentInfo: PaymentInfo(
                  orderId: orderId,
                  orderName:
                      '${widget.basket.first.name}외 ${widget.basket.fold(0, (p, item) => p + item.quantity)}개',
                ),
              );

              if (paymentResult.success != null) {
                //payment status = success
                context.read<OrderBloc>().add(ChangePaymentStatus(
                      orderId: orderId,
                    ));

                context.read<BasketBloc>().add(RemoveMultipleBasket(
                    basketIds: widget.basket.map((e) => e.id).toList()));

                // 결제 성공 처리
                showOrderSuccessDialog(
                  context,
                  widget.basket,
                );

                //원래 결제 화면으로 돌아옴
              } else if (paymentResult.fail != null) {
                print('ORDER ID: ${paymentResult.fail!.orderId}');
                print('ERROR MESSAGE: ${paymentResult.fail!.errorMessage}');
                print('ERROR CODE: ${paymentResult.fail!.errorCode}');
                // 결제 실패 처리
                //snackbar, pop
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('결제 실패'),
                      content: Text('결제에 실패했습니다. 다시 시도해주세요.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
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
            child: const Text('결제하기')),
        ElevatedButton(
            onPressed: () async {
              final selectedPaymentMethod =
                  await _paymentMethodWidgetControl?.getSelectedPaymentMethod();
              print(
                  '${selectedPaymentMethod?.method} ${selectedPaymentMethod?.easyPay?.provider ?? ''}');
            },
            child: const Text('선택한 결제수단 출력')),
        ElevatedButton(
            onPressed: () async {
              final agreementStatus =
                  await _agreementWidgetControl?.getAgreementStatus();
              print('${agreementStatus?.agreedRequiredTerms}');
            },
            child: const Text('약관 동의 상태 출력')),
        ElevatedButton(
            onPressed: () async {
              await _paymentMethodWidgetControl?.updateAmount(amount: 300);
              print('결제 금액이 300원으로 변경되었습니다.');
            },
            child: const Text('결제 금액 변경'))
      ]))
    ])));
  }
}
