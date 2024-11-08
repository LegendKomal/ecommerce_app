import 'package:ecommerce_app/features/cart_list/cart_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartUi extends StatefulWidget {
  const CartUi({super.key});

  @override
  State<CartUi> createState() => _CartUiState();
}

class _CartUiState extends State<CartUi> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartListCubit(),
      child: BlocBuilder<CartListCubit, CartListState>(
        builder: (context, state) {
          if (state is CartListLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is CartListLoaded) {
            final products = state.products;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Cart'),
              ),
              body: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.title),
                    subtitle: Text('₹${product.price.toString()}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        context.read<CartListCubit>().removeFromCart(product);
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is CartListError) {
            return Scaffold(
              body: Center(
                child: Text(state.message),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Cart is empty', style: TextStyle(color: Colors.white)),
              ),
            );
          }
        },
      ),
    );
  }
}