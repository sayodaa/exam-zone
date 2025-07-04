import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/common/animations/animate_do.dart';
import 'package:graduation/core/common/toast/show_toast.dart';
import 'package:graduation/core/common/widgets/app_text_field.dart';
import 'package:graduation/core/common/widgets/custom_app_bar.dart';
import 'package:graduation/core/common/widgets/text_app.dart';
import 'package:graduation/core/extensions/context_extension.dart';
import 'package:graduation/core/language/lang_keys.dart';
import 'package:graduation/core/routes/app_routes.dart';
import 'package:graduation/core/services/shared_pref/pref_keys.dart';
import 'package:graduation/core/services/shared_pref/shared_pref.dart';
import 'package:graduation/core/styles/app_text_styles.dart';
import 'package:graduation/core/styles/styles.dart';
import 'package:graduation/core/utils/app_regex.dart';
import 'package:graduation/features/auth/data/cubit/auth_cubit.dart';
import 'package:graduation/features/auth/presentation/widgets/auth_button.dart';
import 'package:graduation/features/auth/presentation/widgets/google_auth.dart';
import 'package:graduation/features/auth/presentation/widgets/have_auth.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var userNameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignUpFailure) {
            ShowToast.showToastErrorTop(message: state.errorMessage);
          }
          if (state is CreateUserSuccess) {
            Future.delayed(const Duration(seconds: 2), () {
              SharedPref().setString(PrefKeys.uId, state.uId).then((value) {
                if (context.mounted) {
                  context.pushName(AppRoutes.mainV);
                }
              });
              ShowToast.showToastSuccessTop(message: 'Regestration successful');
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        60.h.verticalSpace,
                        CustomAppBar(text: context.translate(LangKeys.appName)),
                        40.h.verticalSpace,
                        CustomFadeInLeft(
                          duration: 700,
                          child: TextApp(
                            text: context.translate(LangKeys.welcome),
                            style: AppTextStyles.bold24(context),
                          ),
                        ),
                        30.h.verticalSpace,
                        CustomFadeInRight(
                          duration: 700,
                          child: AppTextField(
                            controller: userNameController,
                            labelText: "Name",
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null) {
                                return "Please enter your name";
                              }

                              return null;
                            },
                          ),
                        ),
                        16.h.verticalSpace,
                        CustomFadeInRight(
                          duration: 700,
                          child: AppTextField(
                            controller: emailController,
                            labelText: context.translate(LangKeys.email),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null) {
                                return "Please enter your email";
                              } else if (!AppRegex.isEmailValid(
                                emailController.text,
                              )) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: AppColorsStyles.defaultPadding.h,
                        ), // 16.h
                        CustomFadeInRight(
                          duration: 700,
                          child: AppTextField(
                            controller: passwordController,
                            labelText: context.translate(LangKeys.password),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                            onSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                AuthCubit.get(context).signUp(
                                  username: userNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            suffixIcon: AuthCubit.get(context).suffix,
                            suffixIconPressed: () {
                              AuthCubit.get(context).changePasswordVisibility();
                            },
                            obscureText: AuthCubit.get(context).isPassword,
                          ),
                        ),
                        SizedBox(
                          height: AppColorsStyles.defaultPadding.h,
                        ), // 16.h
                        CustomFadeInRight(
                          duration: 700,
                          child: AppTextField(
                            controller: confirmPasswordController,
                            labelText: context.translate(LangKeys.password),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your password";
                              } else if (value != passwordController.text) {
                                return "Password doesn't match";
                              }
                              return null;
                            },
                            suffixIcon: AuthCubit.get(context).suffix,
                            suffixIconPressed: () {
                              AuthCubit.get(context).changePasswordVisibility();
                            },
                            obscureText: AuthCubit.get(context).isPassword,
                          ),
                        ),
                        20.h.verticalSpace,
                        CustomFadeInUp(
                          duration: 700,
                          child: state is! SignUpLoading
                              ? AuthButton(
                                  text: context.translate(LangKeys.signUp),

                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      AuthCubit.get(context).signUp(
                                        username: userNameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                        20.h.verticalSpace,
                        CustomFadeInUp(
                          duration: 700,
                          child: Center(
                            child: Text(
                              context.translate(LangKeys.orContinueWith),
                              style: AppTextStyles.body16(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                        20.h.verticalSpace,
                        CustomFadeInUp(duration: 700, child: GoogleAuth()),
                        CustomFadeInUp(
                          duration: 800,
                          child: HaveAuth(
                            text: context.translate(
                              LangKeys.alreadyHaveAccount,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        20.h.verticalSpace,
                      ],
                    ),
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
