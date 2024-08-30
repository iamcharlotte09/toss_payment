import 'package:commerce_app/bloc/basket.bloc.dart';
import 'package:commerce_app/comp/basket_item_card.comp.dart';
import 'package:commerce_app/comp/custom_button.comp.dart';
import 'package:commerce_app/const/colors.dart';
import 'package:commerce_app/layout/default.layout.dart';
import 'package:commerce_app/model/basket.model.dart';
import 'package:commerce_app/screen/payment.screen.dart';
import 'package:commerce_app/state/basket.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {
      if (state.basket.isNotEmpty) {

        final totalPrice =
        state.basket.fold(0, (p, item) => p + item!.quantity * item.price);

        return DefaultLayout(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 40),
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      const _SliverAppBar(),
                      SliverList.separated(
                          itemCount: state.basket.length,
                          itemBuilder: (context, index) {
                            return BasketItemCard.fromBasketModel(
                              model: state.basket[index]!,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 14);
                          }),
                    ],
                  ),
                ),
                _Bottom(totalPrice: totalPrice),
              ],
            ),
          ),
        );
      }

      return _EmptyScreen();
    });
  }
}

class _EmptyScreen extends StatelessWidget {
  const _EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        leadingWidth: 28,
        backgroundColor: bgColor,
        title: const Text(
          '내 장바구니 \u{1F33F}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      child: const Center(
        child: Text('장바구니가 비었습니다'),
      ),
    );
  }
}

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      leadingWidth: 28,
      backgroundColor: bgColor,
      title: Text(
        '내 장바구니 \u{1F33F}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: false,
    );
  }
}

class _Bottom extends StatelessWidget {
  final int totalPrice;

  const _Bottom({
    required this.totalPrice,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '합계',
              style: textStyle,
            ),
            Text(
              '￦$totalPrice',
              style: textStyle,
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PaymentScreen(
                ),
              ),
            );
          },
          text: '결제하기',
        ),
      ],
    );
  }
}
