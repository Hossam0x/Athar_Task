import 'package:athar_task/presentation/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Login failed"));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'name': name,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });

      emit(AuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Registration failed"));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    emit(AuthInitial());
  }
}
