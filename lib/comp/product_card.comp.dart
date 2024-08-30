import 'package:commerce_app/bloc/basket.bloc.dart';
import 'package:commerce_app/const/colors.dart';
import 'package:commerce_app/event/basket.event.dart';
import 'package:commerce_app/model/product.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final String image;
  final ProductModel model;

  const ProductCard({
    required this.name,
    required this.price,
    required this.image,
    required this.model,
  });

  factory ProductCard.sample() {
    return ProductCard(
      name: '몬스테라',
      price: 30000,
      image: 'asset/img/green_logo.png',
      model: ProductModel(
        imageUrl: 'imageUrl',
        price: 10000,
        name: 'name',
        id: 'id',
      ),
    );
  }

  factory ProductCard.fromProductModel({
    required ProductModel model,
  }) {
    return ProductCard(
      name: model.name,
      price: model.price,
      image: model.imageUrl,
      model: model,
    );
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat('#,###');
    String formattedPrice = '₩${formatter.format(price)}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              Expanded(
                child: Center(
                  child: Image.network(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 8),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _NameAndPrice(
                      name: name,
                      formattedPrice: formattedPrice,
                    ),
                    IconButton(
                      onPressed: () {
                        context
                            .read<BasketBloc>()
                            .add(AddBasket(product: model));
                      },
                      icon: const Icon(
                        Icons.shopping_basket,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameAndPrice extends StatelessWidget {
  final String name;
  final String formattedPrice;

  const _NameAndPrice(
      {required this.name, required this.formattedPrice, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            formattedPrice,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
