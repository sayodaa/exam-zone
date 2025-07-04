import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/app.dart';
import 'package:graduation/core/app/bloc_observer.dart';
import 'package:graduation/core/services/shared_pref/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAMHXVC2wtF-amd2ixM7JNDTa-ahlYPPFY',
      appId: '1:360100096435:android:0f19c9b3ebca2fd9a743c6',
      messagingSenderId: '360100096435',
      projectId: 'online-exam-e718f',
      storageBucket: 'online-exam-e718f.appspot.com',
    ),
  );
  
  await SharedPref().instantiatePreferences();
  Bloc.observer = AppBlocObserver();
  runApp(ExamZone());
}
