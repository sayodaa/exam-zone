import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/animations/animate_do.dart';
import 'package:graduation/core/common/widgets/custom_app_bar.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/styles/app_images.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/profile/cubit/profile_cubit.dart';
import 'package:graduation/core/common/widgets/app_text_field.dart'; // تأكد من مسار AppTextField

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneNumberController = TextEditingController();
    final aboutMeController = TextEditingController();
    final usernameController = TextEditingController();

    return BlocProvider(
      create: (context) => ProfileCubit()..getUserData(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateUserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث الملف الشخصي بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is UpdateUserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل في تحديث الملف: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = ProfileCubit.get(context);
          var userModel = cubit.userModel;

          phoneNumberController.text = userModel.phoneNumber ?? '';
          aboutMeController.text = userModel.aboutMe ?? '';

          usernameController.text = userModel.username ?? '';

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppColorsStyles.defaultPadding.w,
                    vertical: AppColorsStyles.defaultPadding.h * 0.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAppBar(text: 'تعديل الملف الشخصي'),
                      SizedBox(height: AppColorsStyles.defaultPadding.h),

                      // صورة الملف الشخصي
                      CustomFadeInDown(
                        duration: 700,
                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60.r,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                child: CircleAvatar(
                                  radius: 56.r,
                                  foregroundImage: cubit.profileImage != null
                                      ? FileImage(cubit.profileImage!)
                                      : (userModel.personImg != null &&
                                            userModel.personImg!.isNotEmpty)
                                      ? NetworkImage(userModel.personImg!)
                                      : null,
                                  backgroundImage: const AssetImage(
                                    AppImages.logo,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    cubit.pickProfileImage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20.r,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppColorsStyles.defaultPadding.h * 1.5),

                      if (state is GetUserLoading)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        CustomFadeInUp(
                          duration: 700,
                          child: AppTextField(
                            labelText: 'الاسم',
                            controller: usernameController,
                          ),
                        ),
                        SizedBox(height: AppColorsStyles.defaultPadding.h),

                        CustomFadeInUp(
                          duration: 800,
                          child: AppTextField(
                            labelText: 'رقم الهاتف',
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(height: AppColorsStyles.defaultPadding.h),

                        CustomFadeInUp(
                          duration: 900,
                          child: AppTextField(
                            labelText: 'نبذة عني',
                            controller: aboutMeController,
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(height: AppColorsStyles.defaultPadding.h),

                        // زر الحفظ
                        CustomFadeInUp(
                          duration: 1100,
                          child: Center(
                            child: SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton(
                                style:
                                    Theme.of(
                                      context,
                                    ).elevatedButtonTheme.style?.copyWith(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppColorsStyles
                                                .defaultBorderRadius
                                                .r,
                                          ),
                                        ),
                                      ),
                                    ) ??
                                    ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      foregroundColor: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppColorsStyles.defaultBorderRadius.r,
                                        ),
                                      ),
                                    ),
                                onPressed: state is GetUserLoading
                                    ? null
                                    : () {
                                        _saveProfile(
                                          context: context,
                                          cubit: cubit,
                                          usernameController:
                                              usernameController,
                                          phoneNumberController:
                                              phoneNumberController,
                                          aboutMeController: aboutMeController,
                                        );
                                      },
                                child: state is GetUserLoading
                                    ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color ??
                                                    Colors.white,
                                              ),
                                        ),
                                      )
                                    : TextApp(
                                        text: 'حفظ التعديلات',
                                        style: AppTextStyles.body16(
                                          context,
                                        ).copyWith(fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: AppColorsStyles.defaultPadding.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveProfile({
    required BuildContext context,
    required ProfileCubit cubit,
    required TextEditingController usernameController,
    required TextEditingController phoneNumberController,
    required TextEditingController aboutMeController,
  }) {
    cubit.updateUserData(
      name: usernameController.text.trim(),
      image: cubit.profileImage?.path,
    );
  }
}
