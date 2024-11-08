import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/dio/dio_client.dart';

import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial()) {
    fetchProducts();
  }

  DioClient _dioClient = DioClient();
List<Product> baseProducts = [];
  void fetchProducts() async {
    emit(ProductLoading());
    try {
      Response res = await _dioClient.dio.get('/products');
      List<Product> products =
          (res.data as List).map((e) => Product.fromJson(e)).toList();
          baseProducts = products;

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to fetch products'));
    }
  }

  void searchProducts(String query) async {

    if (state is ProductLoaded) {
      final searchResults = query.isEmpty
          ? baseProducts
          : baseProducts
              .where((product) =>
                  product.title.toLowerCase().contains(query.toLowerCase()))
              .toList();

      emit(ProductLoaded(searchResults));
    }
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  // Factory constructor for creating a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
    );
  }

  // Method to convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
    };
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  // Factory constructor for creating a Rating from JSON
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'].toDouble(),
      count: json['count'],
    );
  }

  // Method to convert Rating to JSON
  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}
