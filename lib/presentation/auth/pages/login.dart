
import 'package:athar_task/common/bloc/button/button_state.dart';
import 'package:athar_task/common/bloc/button/button_state_cubit.dart';
import 'package:athar_task/common/helper/app_navigator.dart';
import 'package:athar_task/data/auth/models/userSigninreq.dart';
import 'package:athar_task/domain/auth/usecases/signin.dart';
import 'package:athar_task/presentation/chat/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => ButtonStateCubit(),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) async {
              if (state is ButtonSuccessState) {
                User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  String userId = currentUser.uid;

                  AppNavigator.pushReplacement(
                    context,
                    ChatPage(userId: userId),
                  );
                }
              }
            },
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                BlocBuilder<ButtonStateCubit, ButtonState>(
                  builder: (context, state) {
                    if (state is ButtonLoadingState) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        final userlogin = UserSiginReq(
                          Email: _emailController.text,
                          Password: _passwordController.text,
                        );

                        context.read<ButtonStateCubit>().execute(
                          usecase: SigninUseCase(),
                          params: userlogin,
                        );
                      },
                      child: const Text("Login"),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text("Don't have an account? Register here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
