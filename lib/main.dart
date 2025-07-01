import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/app.dart';
import 'package:graduation/core/app/bloc_observer.dart';
import 'package:graduation/core/services/shared_pref/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref().instantiatePreferences();
  Bloc.observer = AppBlocObserver();
  runApp(ExamZone());
}
