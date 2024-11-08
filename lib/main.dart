import 'package:ecommerce_app/auth/auth_cubit.dart';
import 'package:ecommerce_app/features/product_list/product_list.dart';
import 'package:ecommerce_app/routes/go_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: (kIsWeb)
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory());

  HydratedBloc.storage = storage;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(),
            routerConfig: state.token ==null ? authRoutes : appRoutes,
          );
        },
      ),
    );
  }
}
