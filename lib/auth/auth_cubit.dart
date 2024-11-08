import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/dio/dio_client.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit()
      : super(AuthState(
          token: null,
          status: AuthStatus.initial,
        ));

void register(String token) {
  emit(state.copyWith(
    token: token,
    status: AuthStatus.authenticated,
  ));
}


  void login(String token) async {
    emit(state.copyWith(
      token: token,
      status: AuthStatus.authenticated,
    ));

  }

  void logout() {
    emit(state.copyWith(
      token: null,
      status: AuthStatus.unauthenticated,
    ));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toMap();
  }
}
