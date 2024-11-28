import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'helpers/custom_bloc_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomBlocObserver();
  prefs = await SharedPreferences.getInstance();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    const MultiSweeperApp(),
  );
}
