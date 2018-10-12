import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_github_bloc/api/auth_repo.dart';
import 'package:flutter_github_bloc/bloc/bloc_provider.dart';
import 'package:flutter_github_bloc/bloc/user_bloc.dart';
import 'package:flutter_github_bloc/models/login_view_state.dart';
import 'package:flutter_github_bloc/user_screen.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc implements BlocBase {
  AuthRepo repo;
  BuildContext context;
  var state = LoginViewState();

  var _authController = PublishSubject<LoginViewState>();

  Sink<LoginViewState> get _inViewState => _authController.sink;

  Stream<LoginViewState> get outViewState => _authController.stream;

  PublishSubject _actionController = PublishSubject();

  Sink get login => _actionController.sink;

  Sink get logout => _actionController.sink;

  void setContext(BuildContext context) {
    this.context = context;
  }

  LoginBloc(AuthRepo githubRepo) {
    repo = githubRepo;
    _actionController.stream.listen((data) => _handleLogic(data, context));

    state = LoadingState();
    _inViewState.add(state);
    repo.init().then((alreadyLoggedIn) {
      if (alreadyLoggedIn) {
        repo
            .getSavedUsername()
            .then((username) => navigateToUserScreen(context, username));
      } else {
        state = LoginViewState();
      }
      _inViewState.add(state);
    });
  }

  void dispose() {
    _actionController.close();
    _authController.close();
  }

  void _handleLogic(data, BuildContext context) async {
    state = LoadingState();
    _inViewState.add(state);

    if (data == null) {
      state = LoginViewState();
      _inViewState.add(state);
      repo.logout().then((_) => popToLoginScreen(context));
    }

    if (data is List<String>) {
      String login = data[0];
      String password = data[1];
      repo.login(login, password).then((isSuccess) {
        if (isSuccess) {
          navigateToUserScreen(context, login);
          state = SuccessfulAuthState();
        } else {
          state = FailedAuthState();
        }
        _inViewState.add(state);
      });
    }
  }

  void popToLoginScreen(BuildContext context) => Navigator.of(context).pop();

  void navigateToUserScreen(BuildContext context, String login) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<UserBloc>(
        bloc: UserBloc(repo, login),
        child: UserScreen(),
      );
    }));
  }
}
