import 'package:flutter/material.dart';
import 'package:graduation/core/styles/colors/colors_dark.dart';
import 'package:graduation/core/styles/colors/colors_light.dart';
class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    required this.mainColor,
    required this.bluePinkDark,
    required this.bluePinkLight,
    required this.textColor,
    required this.textFormBorder,
    required this.navBarbg,
    required this.navBarSelectedTab,
    required this.containerShadow1,
    required this.containerShadow2,
    required this.containerLinear1,
    required this.containerLinear2,
  });
  final Color? mainColor;
  final Color? bluePinkDark;
  final Color? bluePinkLight;
  final Color? textColor;
  final Color? textFormBorder;
  final Color? navBarbg;
  final Color? navBarSelectedTab;
  final Color? containerShadow1;
  final Color? containerShadow2;
  final Color? containerLinear1;
  final Color? containerLinear2;

  @override
  ThemeExtension<MyColors> copyWith({
    Color? mainColor,
    Color? bluePinkDark,
    Color? bluePinkLight,
    Color? textColor,
    Color? textFormBorder,
    Color? navBarbg,
    Color? navBarSelectedTab,
    Color? containerShadow1,
    Color? containerShadow2,
    Color? containerLinear1,
  }) {
    return MyColors(
      mainColor: mainColor,
      bluePinkDark: bluePinkDark,
      bluePinkLight: bluePinkLight,
      textColor: textColor,
      textFormBorder: textFormBorder,
      navBarbg: navBarbg,
      navBarSelectedTab: navBarSelectedTab,
      containerShadow1: containerShadow1,
      containerShadow2: containerShadow2,
      containerLinear1: containerLinear1,
      containerLinear2: containerLinear2,
    );
  }

  @override
  ThemeExtension<MyColors> lerp(
    covariant ThemeExtension<MyColors>? other,
    double t,
  ) {
    if (other is! MyColors) {
      return this;
    }
    return MyColors(
      mainColor: mainColor,
      bluePinkDark: bluePinkDark,
      bluePinkLight: bluePinkLight,
      textColor: textColor,
      textFormBorder: textFormBorder,
      navBarbg: navBarbg,
      navBarSelectedTab: navBarSelectedTab,
      containerShadow1: containerShadow1,
      containerShadow2: containerShadow2,
      containerLinear1: containerLinear1,
      containerLinear2: containerLinear2,
    );
  }

  static const MyColors dark = MyColors(
    mainColor: ColorsDark.mainColor,
    bluePinkDark: ColorsDark.blueDark,
    bluePinkLight: ColorsDark.blueLight,
    textColor: ColorsDark.white,
    textFormBorder: ColorsDark.blueLight,
    navBarbg: ColorsDark.navBarDark,
    navBarSelectedTab: ColorsDark.white,
    containerShadow1: ColorsDark.black1,
    containerShadow2: ColorsDark.black2,
    containerLinear1: ColorsDark.black1,
    containerLinear2: ColorsDark.black2,
  );

  static const MyColors light = MyColors(
    mainColor: ColorsLight.mainColor,
    bluePinkDark: ColorsLight.pinkDark,
    bluePinkLight: ColorsLight.pinkLight,
    textColor: ColorsLight.black,
    textFormBorder: ColorsLight.pinkLight,
    navBarbg: ColorsLight.mainColor,
    navBarSelectedTab: ColorsLight.pinkDark,
    containerShadow1: ColorsLight.white,
    containerShadow2: ColorsLight.white,
    containerLinear1: ColorsLight.pinkDark,
    containerLinear2: ColorsLight.pinkLight,
  );
}

// import 'package:flutter/material.dart';
// import 'package:mahmoud_store/core/styles/colors/colors_dark.dart';
// import 'package:mahmoud_store/core/styles/colors/colors_light.dart';
// class MyColors extends ThemeExtension<MyColors> {
//   const MyColors({
//     required this.mainColor,
//     required this.bluePinkDark,
//     required this.bluePinkLight,
//     required this.textColor,
//     required this.textFormBorder,
//     required this.navBarbg,
//     required this.navBarSelectedTab,
//     required this.containerShadow1,
//     required this.containerShadow2,
//     required this.containerLinear1,
//     required this.containerLinear2,
//   });
//   final Color? mainColor;
//   final Color? bluePinkDark;
//   final Color? bluePinkLight;
//   final Color? textColor;
//   final Color? textFormBorder;
//   final Color? navBarbg;
//   final Color? navBarSelectedTab;
//   final Color? containerShadow1;
//   final Color? containerShadow2;
//   final Color? containerLinear1;
//   final Color? containerLinear2;
//   @override
//   ThemeExtension<MyColors> copyWith({
//     Color? mainColor,
//     Color? bluePinkDark,
//     Color? bluePinkLight,
//     Color? textColor,
//     Color? textFormBorder,
//     Color? navBarbg,
//     Color? navBarSelectedTab,
//     Color? containerShadow1,
//     Color? containerShadow2,
//     Color? containerLinear1,
//     Color? containerLinear2,
//   }) {
//     return MyColors(
//       mainColor: mainColor ?? this.mainColor,
//       bluePinkDark: bluePinkDark ?? this.bluePinkDark,
//       bluePinkLight: bluePinkLight ?? this.bluePinkLight,
//       textColor: textColor ?? this.textColor,
//       textFormBorder: textFormBorder ?? this.textFormBorder,
//       navBarbg: navBarbg ?? this.navBarbg,
//       navBarSelectedTab: navBarSelectedTab ?? this.navBarSelectedTab,
//       containerShadow1: containerShadow1 ?? this.containerShadow1,
//       containerShadow2: containerShadow2 ?? this.containerShadow2,
//       containerLinear1: containerLinear1 ?? this.containerLinear1,
//       containerLinear2: containerLinear2 ?? this.containerLinear2,
//     );
//   }
//   @override
//   ThemeExtension<MyColors> lerp(
//     covariant ThemeExtension<MyColors>? other,
//     double t,
//   ) {
//     if (other is! MyColors) return this;
//     return MyColors(
//       mainColor: Color.lerp(mainColor, other.mainColor, t),
//       bluePinkDark: Color.lerp(bluePinkDark, other.bluePinkDark, t),
//       bluePinkLight: Color.lerp(bluePinkLight, other.bluePinkLight, t),
//       textColor: Color.lerp(textColor, other.textColor, t),
//       textFormBorder: Color.lerp(textFormBorder, other.textFormBorder, t),
//       navBarbg: Color.lerp(navBarbg, other.navBarbg, t),
//       navBarSelectedTab: Color.lerp(navBarSelectedTab, other.navBarSelectedTab, t),
//       containerShadow1: Color.lerp(containerShadow1, other.containerShadow1, t),
//       containerShadow2: Color.lerp(containerShadow2, other.containerShadow2, t),
//       containerLinear1: Color.lerp(containerLinear1, other.containerLinear1, t),
//       containerLinear2: Color.lerp(containerLinear2, other.containerLinear2, t),
//     );
//   }
//   static const MyColors dark = MyColors(
//     mainColor: ColorsDark.mainColor,
//     bluePinkDark: ColorsDark.blueDark,
//     bluePinkLight: ColorsDark.blueLight,
//     textColor: ColorsDark.white,
//     textFormBorder: ColorsDark.blueLight,
//     navBarbg: ColorsDark.navBarDark,
//     navBarSelectedTab: ColorsDark.white,
//     containerShadow1: ColorsDark.black1,
//     containerShadow2: ColorsDark.black2,
//     containerLinear1: ColorsDark.black1,
//     containerLinear2: ColorsDark.black2,
//   );
//   static const MyColors light = MyColors(
//     mainColor: ColorsLight.mainColor,
//     bluePinkDark: ColorsLight.pinkDark,
//     bluePinkLight: ColorsLight.pinkLight,
//     textColor: ColorsLight.black,
//     textFormBorder: ColorsLight.pinkLight,
//     navBarbg: ColorsLight.mainColor,
//     navBarSelectedTab: ColorsLight.pinkDark,
//     containerShadow1: ColorsLight.white,
//     containerShadow2: ColorsLight.white,
//     containerLinear1: ColorsLight.pinkDark,
//     containerLinear2: ColorsLight.pinkLight,
//   );
// }// لتدعم التدرج اللوني (Linear Interpolation)
