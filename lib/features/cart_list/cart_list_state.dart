part of 'cart_list_cubit.dart';

@immutable
sealed class CartListState {}

class CartListInitial extends CartListState {}

class CartListLoading extends CartListState {}

class CartListLoaded extends CartListState {
  final List<Product> products;
  CartListLoaded(this.products);
}

class CartListError extends CartListState {
  final String message;
  CartListError(this.message);
}