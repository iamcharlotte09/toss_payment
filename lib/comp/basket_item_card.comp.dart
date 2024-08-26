import 'package:commerce_app/bloc/basket.bloc.dart';
import 'package:commerce_app/const/colors.dart';
import 'package:commerce_app/event/basket.event.dart';
import 'package:commerce_app/model/basket.model.dart';
import 'package:commerce_app/model/order.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketItemCard extends StatelessWidget {
  final String name;
  final String price;
  final int quantity;
  final String image;
  final bool isOrderCard;
  final BasketModel model;

  const BasketItemCard({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    this.isOrderCard = false,
    required this.model,
  });

  factory BasketItemCard.sample({
    bool isOrderCard = false,
  }) {
    return BasketItemCard(
      name: '몬스테라',
      price: '30,000',
      quantity: 2,
      image: 'asset/img/green_logo.png',
      isOrderCard: isOrderCard,
      model: BasketModel(
        imageUrl: 'imageUrl',
        price: 30000,
        name: 'name',
        id: 'id',
        quantity: 1,
      ),
    );
  }

  factory BasketItemCard.fromBasketModel({
    required BasketModel model,
  }) {
    return BasketItemCard(
      name: model.name,
      price: model.price.toString(),
      quantity: model.quantity,
      image: model.imageUrl,
      model: model,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.network(
                image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Top(
                      name: name,
                      price: price,
                    ),
                    if (model is! OrderModel)
                      _BasketBottom(
                        basket: model,
                      ),
                    if (model is OrderModel)
                      _OrderBottom(
                        model: model as OrderModel,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Top extends StatelessWidget {
  final String name;
  final String price;

  const _Top({required this.name, required this.price, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '￦$price',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _BasketBottom extends StatelessWidget {
  final BasketModel basket;

  const _BasketBottom({required this.basket, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: bgColor,
            height: 40,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: primaryColor,
                    size: 18,
                  ),
                  onPressed: () {
                    context.read<BasketBloc>().add(SubtractBasket(
                          product: basket,
                        ));
                  },
                ),
                Text(
                  '${basket.quantity}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: primaryColor,
                    size: 18,
                  ),
                  onPressed: () {
                    context.read<BasketBloc>().add(AddBasket(
                          product: basket,
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            context.read<BasketBloc>().add(SubtractBasket(
                  product: basket,
                  isRemoveAll: true,
                ));

          },
        ),
      ],
    );
  }
}

class _OrderBottom extends StatelessWidget {
  final OrderModel model;

  const _OrderBottom({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${model.name} 외 ${model.quantity}개'),
        Text(
            '${model.createdAt.year}-${model.createdAt.month}-${model.createdAt.day}'),
      ],
    );
  }
}
