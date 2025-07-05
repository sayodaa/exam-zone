import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation/features/auth/data/model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  void login({required String email, required String password}) {
    emit(LoginLoading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          log(value.user!.email.toString());
          log(value.user!.uid.toString());
         
          emit(LoginSuccess(value.user!.uid));
        })
        .catchError((error) {
          // log(error.message);
          emit(LoginFailure(error.message));
        });
  }

  void signUp({
    required String username,
    required String email,
    required String password,
  }) {
    emit(SignUpLoading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
          log(value.user!.email.toString());
          log(value.user!.uid.toString());
          createuser(
            email: email,
            password: password,
            username: username,
            uId: value.user!.uid,
          );

          //emit(SignUpSuccess()); ملوش لازمه هنا
        })
        .catchError((error) {
          log(error.message);
          emit(SignUpFailure(error.message));
        });
  }

  void createuser({
    required String username,
    required String email,
    required String password,
    required String uId,
  }) {
    UserModel model = UserModel(
      username: username,
      email: email,
      personImg:
          'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?t=st=1731808878~exp=1731812478~hmac=afd6c0164d6c143e908928d3d3b78ab0d481e3450013804a2de6057e50529644&w=740',

      password: password,
      uId: uId,
    );

    FirebaseFirestore.instance
        .collection('accounts')
        .doc(uId)
        .set(model.toMap())
        .then((onValue) {
          // log('Create User succuss');
          emit(CreateUserSuccess(uId));
        })
        .catchError((onError) {
          log('Create user error');
          emit(CreateUserFailure(onError.toString()));
        });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(PasswordVisibility());
  }
}
