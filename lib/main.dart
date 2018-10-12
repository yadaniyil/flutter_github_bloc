import 'package:flutter/material.dart';
import 'package:flutter_github_bloc/api/auth_repo.dart';
import 'package:flutter_github_bloc/bloc/bloc_provider.dart';
import 'package:flutter_github_bloc/bloc/login_bloc.dart';
import 'package:flutter_github_bloc/login_screen.dart';

void main() {
  var authRepo = AuthRepo();
  runApp(BlocProvider<LoginBloc>(
    bloc: LoginBloc(authRepo),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Github Bloc',
        theme: ThemeData(
            primarySwatch: Colors.blueGrey, accentColor: Colors.blueGrey),
        home: LoginScreen());
  }
}
