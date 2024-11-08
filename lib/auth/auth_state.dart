part of 'auth_cubit.dart';

enum AuthStatus { authenticated, unauthenticated, loading, error, initial }

class AuthState {
  String? token;
  AuthStatus status;

  AuthState({
    required this.token,
    required this.status,
  });

  AuthState copyWith({
    String? token,
    AuthStatus? status,
  }) {
    return AuthState(
      token: token ?? this.token,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'status': status.toString().split('.').last, // Convert enum to string
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      token: map['token'],
      status: AuthStatus.values.firstWhere((e) =>
          e.toString().split('.').last ==
          map['status']), // Convert string to enum
    );
  }
}
