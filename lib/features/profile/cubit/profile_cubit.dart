import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/utils/app_string.dart';
import 'package:graduation/features/auth/data/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  UserModel userModel = UserModel(
    username: '',
    personImg: '',
    email: '',
    password: '',
    uId: '',
    isAdmin: false,
    phoneNumber: '',
    aboutMe: '',
    examCreated: '',
    dateJoin: '',
  );

  Future<void> getUserData() async {
    emit(GetUserLoading());
    FirebaseFirestore.instance
        .collection('accounts')
        .doc(AppString.uId)
        .get()
        .then((value) {
          log('${value.data()}getUserData  ');
          final data = value.data();
          log('Firebase data: $data');
          if (data != null) {
            userModel = UserModel.fromJson(data);
            log("Loaded user image: ${userModel.personImg}");
            emit(GetUserSuccess());
          } else {
            emit(GetUserFailure('User data is null'));
          }
        })
        .catchError((error) {
          log('Error fetching user: $error');
          emit(GetUserFailure(error.toString()));
        });
  }

  File? profileImage;
  final picker = ImagePicker();
  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      log(profileImage?.path ?? 'null profile image path');
      emit(GetProfileImageSuccess());
    } else {
      log('no image selected');
      emit(GetProfileImageFailure());
    }
  }

  Future<void> updateUserData({String? name, String? image}) async {
    UserModel model = UserModel(
      username: name ?? userModel.username,
      personImg: image ?? userModel.personImg,

      phoneNumber: userModel.phoneNumber,
      aboutMe: userModel.aboutMe,
      examCreated: userModel.examCreated,
      dateJoin: userModel.dateJoin,
      email: userModel.email,
      password: userModel.password,
      uId: userModel.uId,
      isAdmin: userModel.isAdmin,
    );

    FirebaseFirestore.instance
        .collection('accounts')
        .doc(AppString.uId)
        .update(model.toMap())
        .then((value) {
          getUserData();
          log('User updated successfully');
          emit(UpdateUserSuccess());
        })
        .catchError((error) {
          log('Error updating user: $error');
          emit(UpdateUserFailure(error.toString()));
        });
  }
}
