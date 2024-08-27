import 'package:commerce_app/bloc/auth.bloc.dart';
import 'package:commerce_app/bloc/order.bloc.dart';
import 'package:commerce_app/comp/basket_item_card.comp.dart';
import 'package:commerce_app/const/colors.dart';
import 'package:commerce_app/event/order.event.dart';
import 'package:commerce_app/layout/default.layout.dart';
import 'package:commerce_app/screen/auth.screen.dart';
import 'package:commerce_app/screen/products.screen.dart';
import 'package:commerce_app/state/auth.state.dart';
import 'package:commerce_app/state/order.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrders());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: CustomScrollView(
          slivers: [
            const _SliverAppBar(),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state.orders.isNotEmpty) {
                  return SliverList.separated(
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return BasketItemCard.fromBasketModel(
                          model: state.orders[index]!,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 14);
                      });
                }
                return SliverToBoxAdapter(
                  child: const Center(
                    child: Text('주문한 내역이 없습니다'),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: bgColor,
      automaticallyImplyLeading: false,
      title: const Text(
        '내 주문 내역 \u{1F333}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductsScreen(),
              ),
            );
          },
          icon: const Icon(Icons.home),
        )
      ],
    );
  }
}
