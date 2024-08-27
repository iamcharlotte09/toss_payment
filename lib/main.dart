import 'package:commerce_app/bloc/auth.bloc.dart';
import 'package:commerce_app/bloc/basket.bloc.dart';
import 'package:commerce_app/bloc/order.bloc.dart';
import 'package:commerce_app/bloc/product.bloc.dart';
import 'package:commerce_app/repository/auth.repository.dart';
import 'package:commerce_app/repository/order.repository.dart';
import 'package:commerce_app/repository/product.repository.dart';
import 'package:commerce_app/screen/auth.screen.dart';
import 'package:commerce_app/screen/products.screen.dart';
import 'package:commerce_app/state/auth.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as S;

void main() async {
  ///1. supabase 설정
  await S.Supabase.initialize(
    url: 'https://tkyolagwiyiqrbxwtkkv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRreW9sYWd3aXlpcXJieHd0a2t2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU4MjkwNTksImV4cCI6MjAzMTQwNTA1OX0.gCKgb5eT5QcTSkzVI38y0Tas50u1T61xNH6ycD1DSVE',
  );

  final supabase = S.Supabase.instance.client;

  final productRepository = ProductRepository(
    supabase: supabase,
  );

  final orderRepository = OrderRepository(
    supabase: supabase,
  );

  final authRepository = AuthRepository(
    supabase: supabase,
  );

  runApp(
    MyApp(
      productRepository: productRepository,
      orderRepository: orderRepository,
      authRepository: authRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;
  final OrderRepository orderRepository;
  final AuthRepository authRepository;

  const MyApp(
      {required this.productRepository,
      required this.orderRepository,
      required this.authRepository,
      super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(repository: authRepository),
        ),
        BlocProvider(
          create: (context) => ProductBloc(repository: productRepository),
        ),
        BlocProvider(
          create: (context) => BasketBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(
            repository: orderRepository,
            authBloc: context.read<AuthBloc>()
          ),
        ),
      ],
      child: MaterialApp(
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.user != null) {
              return ProductsScreen();
            } else {
              return AuthScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
