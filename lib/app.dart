import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/language/app_localizations_setup.dart';
import 'package:graduation/core/routes/app_routes.dart';
import 'package:graduation/core/styles/theme/app_themes_styles.dart';
import 'package:graduation/core/styles/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ExamZone extends StatelessWidget {
  const ExamZone({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //  BlocProvider(
        //       create: (context) => AppCubit()
        //         ..changeAppThemeMode(
        //           sharedMode: true,
        //         ) //SharedPref().getBoolean(PrefKeys.themeMode)
        //         ..getSavedLanguage(),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return GestureDetector(
                onTap: () {
                  // إلغاء تركيز لوحة المفاتيح عند النقر خارج الحقول
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: MaterialApp(
                  locale: Locale('ar'), //Locale(cubit.currentLangCode),
                  localizationsDelegates:
                      AppLocalizationsSetup.localizationsDelegates,
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  localeResolutionCallback:
                      AppLocalizationsSetup.localeResolutionCallback,

                  debugShowCheckedModeBanner: false,
                  theme: AppThemes.lightTheme,
                  darkTheme: AppThemes.darkTheme,
                  themeMode: themeProvider.themeMode,
                  initialRoute: AppRoutes.splash,
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
