import 'package:ecommerce_app/features/cart_list/cart_list_cubit.dart';
import 'package:ecommerce_app/features/cart_list/cart_ui.dart';
import 'package:ecommerce_app/features/product_list/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductCubit()..fetchProducts()),
        BlocProvider(create: (context) => CartListCubit()),
      ],
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, productState) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartUi()),
                );
              },
              child: const Icon(Icons.shopping_cart),
            ),
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              title: const Text('Product List'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card.filled(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: TextField(
                      decoration: const InputDecoration(
                        label: Text('Search Products'),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      onChanged: (query) {
                        context.read<ProductCubit>().searchProducts(query);
                      },
                    ),
                  ),
                  productState is ProductLoading
                      ? const LinearProgressIndicator()
                      : productState is ProductLoaded
                          ? Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.all(12),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.55,
                                ),
                                itemCount: productState.products.length,
                                itemBuilder: (context, index) {
                                  final product = productState.products[index];
                                  return Card.filled(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              product.image,
                                              fit: BoxFit.cover,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                              width: double.infinity,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            product.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "₹${product.price.toString()}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: BlocConsumer<CartListCubit,
                                                    CartListState>(
                                                  listener: (context, state) {
                                                    if (state is CartListLoaded) {
                                                      Fluttertoast.showToast(
                                                        msg: "Product added to cart",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                      );
                                                    }
                                                  },
                                                  builder: (context, state) {
                                                    return FilledButton.icon(
                                                      icon: const Icon(
                                                          Icons.add_shopping_cart),
                                                      label: const Text('Add to Cart'),
                                                      onPressed: () {
                                                        context
                                                            .read<CartListCubit>()
                                                            .addToCart(product);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : productState is ProductError
                              ? Text(productState.message)
                              : const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}