import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/animations/animate_do.dart';
import 'package:graduation/core/common/widgets/custom_app_bar.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/routes/app_routes.dart';
import 'package:graduation/core/styles/app_images.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/features/profile/cubit/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getUserData(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = ProfileCubit.get(context).userModel;
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
                      CustomAppBar(text: context.translate(LangKeys.profile)),
                      SizedBox(height: AppColorsStyles.defaultPadding.h),
                      CustomFadeInDown(
                        duration: 700,
                        child: Center(
                          child: CircleAvatar(
                            radius: 60.r,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            child: CircleAvatar(
                              radius: 56.r,
                              foregroundImage:
                                  (userModel.personImg != null &&
                                      userModel.personImg!.isNotEmpty)
                                  ? NetworkImage(userModel.personImg!)
                                  : null,
                              backgroundImage: const AssetImage(AppImages.logo),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppColorsStyles.defaultPadding.h * 0.75),
                      CustomFadeInUp(
                        duration: 700,
                        child: Center(
                          child: TextApp(
                            text: userModel.username ?? 'john doe',
                            style: AppTextStyles.bold24(context),
                          ),
                        ),
                      ),
                      SizedBox(height: AppColorsStyles.defaultPadding.h * 0.5),
                      CustomFadeInUp(
                        duration: 800,
                        child: Center(
                          child: TextApp(
                            text: userModel.email ?? 'john.doe@example.com',
                            style: AppTextStyles.body16(context).copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppColorsStyles.defaultPadding.h * 0.5),
                      CustomFadeInUp(
                        duration: 800,
                        child: Center(
                          child: TextApp(
                            text: userModel.phoneNumber ?? '0123456789',
                            style: AppTextStyles.body16(context).copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppColorsStyles.defaultPadding.h),
                      CustomFadeInLeft(
                        duration: 700,
                        child: Card(
                          elevation: 2,
                          color: Theme.of(context).cardTheme.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppColorsStyles.defaultBorderRadius.r,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              AppColorsStyles.defaultPadding.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextApp(
                                  text: context.translate(LangKeys.aboutMe),
                                  style: AppTextStyles.body16(
                                    context,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height:
                                      AppColorsStyles.defaultPadding.h * 0.5,
                                ),
                                TextApp(
                                  text:
                                      userModel.aboutMe ??
                                      "Let others know a little more about you.",
                                  style: AppTextStyles.body16(context),
                                ),
                                SizedBox(
                                  height: AppColorsStyles.defaultPadding.h,
                                ),
                                TextApp(
                                  text:
                                      '${context.translate(LangKeys.examCreated)}: ${userModel.examCreated ?? '0'}',
                                  style: AppTextStyles.body16(context),
                                ),
                                SizedBox(
                                  height:
                                      AppColorsStyles.defaultPadding.h * 0.5,
                                ),
                                TextApp(
                                  text:
                                      '${context.translate(LangKeys.joined)}: ${userModel.dateJoin ?? "January 2025"}',
                                  style: AppTextStyles.body16(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppColorsStyles.defaultPadding.h),
                      CustomFadeInRight(
                        duration: 700,
                        child: Center(
                          child: ElevatedButton(
                            style:
                                Theme.of(
                                  context,
                                ).elevatedButtonTheme.style?.copyWith(
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppColorsStyles.defaultBorderRadius.r,
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
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.editProfile,
                              );
                            },
                            child: TextApp(
                              text:context.translate(LangKeys.editProfile),
                              style: AppTextStyles.body16(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
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
}
