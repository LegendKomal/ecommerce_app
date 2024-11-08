import 'package:ecommerce_app/auth/sign_in.dart';
import 'package:ecommerce_app/features/product_list/product_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter authRoutes = GoRouter(initialLocation: '/login', routes: [
  GoRoute(
    path: '/login',
    builder: (context, state) => SignIn(),
  ),
]);

GoRouter appRoutes = GoRouter(
  initialLocation: '/',
  routes: [
    //home , cart, checkout, viewprodcut
    GoRoute(
      path: '/',
      builder: (context, state) => ProductListPage(),
    ),
    GoRoute(path: '/cart', builder: (context, state) => Container()),
    GoRoute(path: '/checkout', builder: (context, state) => Container()),
    GoRoute(path: '/viewproduct', builder: (context, state) => Container()),
  ],
);
