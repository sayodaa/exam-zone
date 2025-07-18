import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/language/app_localizations_setup.dart';
import 'package:graduation/core/routes/app_routes.dart';
import 'package:graduation/core/services/shared_pref/pref_keys.dart';
import 'package:graduation/core/services/shared_pref/shared_pref.dart';
import 'package:graduation/core/styles/theme/app_themes_styles.dart';
import 'package:graduation/core/styles/theme/theme_provider.dart';
import 'package:graduation/core/utils/app_string.dart';
import 'package:graduation/features/overwall/presentation/cubit/generate_cubit.dart';
import 'package:provider/provider.dart';

class ExamZone extends StatelessWidget {
  const ExamZone({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (_) => GenerateExamCubit()),
      ],
      child: const ExamZoneApp(),
    );
  }
}

class ExamZoneApp extends StatelessWidget {
  const ExamZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        bool? onboard = SharedPref().getBoolean(PrefKeys.onBoarding);
        AppString.uId = SharedPref().getString(PrefKeys.uId);
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MaterialApp(
            locale: themeProvider.currentLocale,
            localizationsDelegates:
                AppLocalizationsSetup.localizationsDelegates,
            supportedLocales: AppLocalizationsSetup.supportedLocales,
            localeResolutionCallback:
                AppLocalizationsSetup.localeResolutionCallback,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppString.uId != null
                ? AppRoutes.mainV
                : onboard != null
                ? AppRoutes.login
                : AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          ),
        );
      },
    );
  }
}
