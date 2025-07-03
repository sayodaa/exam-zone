import 'dart:developer';

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
  //     void register({
  //     required String username,
  //     required String email,
  //     required String password,
  //     required String phone,
  //   }) {
  //     emit(RegisterLoading());
  //     FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     )
  //         .then((value) {
  //       // print(value.user?.email);
  //       // print(value.user?.uid);
  //       createuser(
  //           email: email,
  //           password: password,
  //           phone: phone,
  //           username: username,
  //           uId: value.user!.uid);

  // //emit(RegisterSuccess()); ملوش لازمه هنا
  //     }).catchError((error) {
  //       //  print(error.message);
  //       emit(RegisterFailure(error.message));
  //     });
  //   }

  //   void createuser({
  //     required String username,
  //     required String email,
  //     required String password,
  //     required String phone,
  //     required String uId,
  //   }) {
  //     UserModel model = UserModel(
  //       name: username,
  //       email: email,
  //       phone: phone,
  //       image:
  //           'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?t=st=1731808878~exp=1731812478~hmac=afd6c0164d6c143e908928d3d3b78ab0d481e3450013804a2de6057e50529644&w=740',
  //       coverimage:
  //           'https://img.freepik.com/free-photo/top-view-table-full-food_23-2149209253.jpg?t=st=1733939046~exp=1733942646~hmac=8bf765bd09d80d16a74fb36b01daa7c80d2d11a9d402c8e92686a6530cd0a804&w=996',
  //       bio: 'wrrite your bio ...',
  //       password: password,
  //       uId: uId,
  //       isEmailVerified: emailVerified,
  //     );

  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(
  //           uId,
  //         )
  //         .set(
  //           model.toMap(),
  //         )
  //         .then((onValue) {
  //       // print('Create User succuss');
  //       emit(CreateUserSuccess(uId));
  //     }).catchError((onError) {
  //       //  print('Create user error');
  //       emit(CreateUserFailure(onError.toString()));
  //     });
  //   }

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
