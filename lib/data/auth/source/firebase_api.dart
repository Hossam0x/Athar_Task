import 'package:athar_task/data/auth/models/userSigninreq.dart';
import 'package:athar_task/data/auth/models/userSignup.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthFirebaseService {

  Future<Either> signup(UserCreationReq user);
  Future<Either> signin(UserSiginReq user);
  Future<Either>getUser();


}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  @override
  Future<Either> signup(UserCreationReq user) async{
      try {
      var returnedData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.Email!, password: user.Password!);
      FirebaseFirestore.instance
          .collection('users')
          .doc(returnedData.user!.uid)
          .set({
          'id':returnedData.user!.uid,
        'Name': user.name,
        'email': user.Email,
        'isTyping':false 
      });
      return const Right('Sign Up was Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signin(UserSiginReq user) async{
    try{
        var returnedData = await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.Email!, password: user.Password!);

        return const Right(
          'Sign in successfully',
        );
      } on FirebaseAuthException catch (e) {
        String message = '' ;
      if(e.code == 'invalid-email'){
        message = 'Not user found for that email' ;
      }   
      else if (e.code == 'invalid-credentials'){
        message = 'Wrong password provided for that user';
      }

      return Left(message);
  }
  }
  
  @override
  Future<Either> getUser()async {
    try {
  var currentUser = await FirebaseAuth.instance.currentUser;
  var userData =await FirebaseFirestore.instance.collection('users').doc(
    currentUser?.uid
  ).get().then((onValue) => onValue.data());
  
  return Right(userData);
} catch (e) {
  return left("Please try again");
}
  }

}