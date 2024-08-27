import 'package:commerce_app/bloc/auth.bloc.dart';
import 'package:commerce_app/bloc/basket.bloc.dart';
import 'package:commerce_app/bloc/product.bloc.dart';
import 'package:commerce_app/comp/product_card.comp.dart';
import 'package:commerce_app/const/colors.dart';
import 'package:commerce_app/event/auth.event.dart';
import 'package:commerce_app/event/product.event.dart';
import 'package:commerce_app/layout/default.layout.dart';
import 'package:commerce_app/screen/auth.screen.dart';
import 'package:commerce_app/screen/basket.screen.dart';
import 'package:commerce_app/screen/orders.screen.dart';
import 'package:commerce_app/state/auth.state.dart';
import 'package:commerce_app/state/basket.state.dart';
import 'package:commerce_app/state/product.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProducts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.user == null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const AuthScreen(
                    isLogin: true,
                  )));
        }
      },
      child: BlocBuilder<BasketBloc, BasketState>(
        builder: (context, state) {
          final itemCount = state.basket.isEmpty
              ? null
              : state.basket
                  .fold(0, (sum, item) => sum + item!.quantity)
                  .toString();

          return DefaultLayout(
            fab: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BasketScreen(),
                  ),
                );
              },
              child: itemCount != null
                  ? Badge(
                      label: Text(itemCount),
                      child: const Icon(
                        Icons.shopping_basket,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.shopping_basket,
                      color: Colors.white,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: CustomScrollView(
                slivers: [
                  _SliverAppBar(),
                  _Title(),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ErrorProductState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('장바구니를 불러오기 실패했습니다.')));

                        return SliverToBoxAdapter(
                          child: Center(
                            child: TextButton(
                              onPressed: () {},
                              child: Text('다시 가져오기'),
                            ),
                          ),
                        );
                      }
                      if (state is LoadingProductState ||
                          state is InitialProductState) {
                        return const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (state is LoadedProductState) {
                        return SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 3 / 4,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return ProductCard.fromProductModel(
                                  model: state.products[index]);
                            },
                            childCount: 10,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrdersScreen(),
              ),
            );
          },
          child: const Text(
            '내 주문',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(Logout());
          },
          child: const Icon(
            Icons.logout,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //'\u{}' 안에 넣고자 하는 이모지의 유니코드를 입력하면 된다.
          //Emoji(이모티콘)들의 유니코드는 아래의 사이트에서 참고하여 사용하면 된다.
          // U+이후의 부분을 괄호 안에 작성해주면 된다.
          // https://apps.timwhitlock.info/emoji/tables/unicode
          Text(
            '가장 인기많은 식물  \u{1f60e} \u{1F680}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
