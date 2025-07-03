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

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            if (state.errorMessage == 'user-not-found') {
              ShowToast.showToastErrorTop(
                message: 'No user found for that email.',
              );
            } else if (state.errorMessage == 'wrong-password') {
              ShowToast.showToastErrorTop(
                message: 'Wrong password provided for that user.',
              );
            } else {
              ShowToast.showToastErrorTop(message: state.errorMessage);
            }
          }
          if (state is LoginSuccess) {
            Future.delayed(const Duration(seconds: 2), () {
              SharedPref().setString(PrefKeys.uId, state.uId).then((value) {
                if (context.mounted) {
                  context.pushNamedAndRemoveUntil(AppRoutes.settingsView);
                }
              });
              ShowToast.showToastSuccessTop(message: 'Login successful');
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppColorsStyles.defaultPadding.w,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: AppColorsStyles.defaultPadding.h * 3.75,
                        ), // Approx 60.h
                        CustomAppBar(text: context.translate(LangKeys.appName)),
                        SizedBox(
                          height: AppColorsStyles.defaultPadding.h * 2.5,
                        ), // Approx 40.h
                        CustomFadeInLeft(
                          duration: 700,
                          child: TextApp(
                            text: context.translate(LangKeys.welcomeBack),
                            style: AppTextStyles.bold24(context),
                          ),
                        ),
                        SizedBox(
                          height: AppColorsStyles.defaultPadding.h * 1.875,
                        ), // Approx 30.h
                        CustomFadeInRight(
                          duration: 700,
                          child: AppTextField(
                            controller: emailController,
                            labelText: context.translate(LangKeys.email),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (!AppRegex.isEmailValid(
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
                                AuthCubit.get(context).login(
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
                          height: AppColorsStyles.defaultPadding.h * 0.625,
                        ), // Approx 10.h
                        CustomFadeInLeft(
                          duration: 600,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style:
                                  Theme.of(
                                    context,
                                  ).textButtonTheme.style?.copyWith(
                                    foregroundColor: WidgetStateProperty.all(
                                      Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withValues(alpha: 0.7),
                                    ),
                                  ) ??
                                  TextButton.styleFrom(
                                    foregroundColor: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                              onPressed: () {},
                              child: TextApp(
                                text: context.translate(
                                  LangKeys.forgotPassword,
                                ),
                                style: AppTextStyles.body14(context).copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppColorsStyles.defaultPadding.h * 0.625,
                        ), // Approx 10.h
                        state is! LoginLoading
                            ? CustomFadeInUp(
                                duration: 700,
                                child: AuthButton(
                                  text: context.translate(LangKeys.login),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      AuthCubit.get(context).login(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                      context
                                          .pushNamedAndRemoveUntil(
                                        AppRoutes.mainV,
                                      );
                                    }
                                  },
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),
                        SizedBox(
                          height: AppColorsStyles.defaultPadding.h * 1.25,
                        ), // Approx 20.h
                        CustomFadeInUp(
                          duration: 700,
                          child: Center(
                            child: TextApp(
                              text: context.translate(LangKeys.orContinueWith),
                              style: AppTextStyles.body14(context).copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppColorsStyles.defaultPadding.h,
                        ), // 16.h
                        CustomFadeInUp(duration: 700, child: GoogleAuth()),
                        CustomFadeInUp(
                          duration: 800,
                          child: HaveAuth(
                            text: context.translate(
                              LangKeys.alreadyHaveAccount,
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, AppRoutes.signUp),
                          ),
                        ),
                        SizedBox(
                          height: AppColorsStyles.defaultPadding.h * 1.25,
                        ), // Approx 20.h
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
