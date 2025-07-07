part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class GetUserLoading extends ProfileState {}

class GetUserSuccess extends ProfileState {}

class GetUserFailure extends ProfileState {
  final String message;
  GetUserFailure(this.message);
}

class GetProfileImageSuccess extends ProfileState {}

class GetProfileImageFailure extends ProfileState {}

class UpdateUserFailure extends ProfileState {}
