import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecommerce_app/auth/auth_cubit.dart';
import 'package:ecommerce_app/auth/sing_up.dart';
import 'package:ecommerce_app/dio/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                state.status == AuthStatus.error
                    ? const Text('Invalid Credentials')
                    : const SizedBox(),
                state.status == AuthStatus.loading
                    ? const LinearProgressIndicator()
                    : const SizedBox(),
                Card.filled(
                  child: TextField(
                    enabled: state.status != AuthStatus.loading,
                    controller: usernameController,
                    decoration: const InputDecoration(
                      label: Text('Username'),
                      prefixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Card.filled(
                  child: TextField(
                    enabled: state.status != AuthStatus.loading,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      prefixIcon: Icon(Icons.lock),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: FilledButton(
                          onPressed: () async {
                            // Check if username and password fields are not empty
                            final username = usernameController.text.trim();
                            final password = passwordController.text.trim();

                            if (username.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Username and password cannot be empty')),
                              );
                              return;
                            }



                            try {
                              // Making the POST request
                              final url = Uri.parse('https://fakestoreapi.com/auth/login');
                              final response = await http.post(
                                url,
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode({
                                  'username': username,
                                  'password': password,
                                }),
                              );

                              // Handling the response
                              if (response.statusCode == 200) {
                                final data = jsonDecode(response.body); // Parse the JSON response
                                if (data['token'] != null) {
                                  debugPrint('Token: ${data['token']}');
                                  context.read<AuthCubit>().login(data['token']);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Login successful!')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Invalid credentials, please try again.')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Login failed. Please try again.')),
                                );
                              }
                            } catch (e) {
                              // Handle network or unexpected errors
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('An error occurred. Please try again later. ${e.toString()}')),
                              );
                            }

                          },

                          child: const Text('Login'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SingUp()),
                );
                          },
                          child: const Text('Register'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
