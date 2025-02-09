
import 'package:athar_task/common/bloc/button/button_state.dart';
import 'package:athar_task/common/bloc/button/button_state_cubit.dart';
import 'package:athar_task/common/helper/app_navigator.dart';
import 'package:athar_task/data/auth/models/userSignup.dart';
import 'package:athar_task/domain/auth/usecases/signup.dart';
import 'package:athar_task/presentation/chat/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) => ButtonStateCubit(),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
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
              BlocConsumer<ButtonStateCubit, ButtonState>(
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
                builder: (context, state) {
                  if (state is ButtonLoadingState) {
                    return const CircularProgressIndicator();
                  }

                  return ElevatedButton(
                    onPressed: () {
                      final userCreationRequest = UserCreationReq(
                        name: _nameController.text,
                        Email: _emailController.text,
                        Password: _passwordController.text,
                      );
                      context.read<ButtonStateCubit>().execute(
                        usecase: SignupUseCase(),
                        params: userCreationRequest,
                      );
                    },
                    child: const Text("Register"),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("Already have an account? Login here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
