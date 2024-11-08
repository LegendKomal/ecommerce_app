import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/features/product_list/product_cubit.dart';
import 'package:meta/meta.dart';

part 'cart_list_state.dart';

class CartListCubit extends Cubit<CartListState> {
  CartListCubit() : super(CartListInitial()) {
    _loadInitialCartItems();
  }

  final List<Product> _cartItems = [];

  List<Product> get cartItems => List.unmodifiable(_cartItems);

  void _loadInitialCartItems() {
    // Load the initial cart items from a data source or initialize an empty list
    _cartItems.addAll([]);
    emit(CartListLoaded(cartItems));
  }

  void addToCart(Product product) {
    if (!_cartItems.contains(product)) {
      _cartItems.add(product);
      emit(CartListLoaded(cartItems));
    }
  }

  void removeFromCart(Product product) {
    if (_cartItems.contains(product)) {
      _cartItems.remove(product);
      emit(CartListLoaded(cartItems));
    }
  }
}