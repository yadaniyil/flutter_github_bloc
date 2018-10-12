import 'package:flutter/material.dart';
import 'package:flutter_github_bloc/bloc/bloc_provider.dart';
import 'package:flutter_github_bloc/bloc/login_bloc.dart';
import 'package:flutter_github_bloc/models/login_view_state.dart';
import 'package:flutter_github_bloc/widgets/loading_indicator.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    final loginController = TextEditingController();
    final passwordController = TextEditingController();

    loginBloc.setContext(context);

    return Scaffold(
      appBar: AppBar(title: Text('Flutter Github Bloc')),
      body: StreamBuilder<LoginViewState>(
          stream: loginBloc.outViewState,
          initialData: LoginViewState(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.data is LoadingState) {
              return LoadingIndicator();
            } else if (snapshot.data is FailedAuthState) {
              return getLoginView(
                  true, loginBloc, loginController, passwordController);
            } else if (snapshot.data is LoginViewState) {
              return getLoginView(
                  false, loginBloc, loginController, passwordController);
            }
          }),
    );
  }

  Widget getLoginView(bool badCredentials,
      LoginBloc loginBloc,
      TextEditingController loginController,
      TextEditingController passwordController) {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: ListView(
        children: <Widget>[
          _showBadCredentials(badCredentials),
          TextFormField(
              controller: loginController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Login',
                border: OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(24.0))),
              )),
          SizedBox(height: 24.0),
          TextFormField(
              controller: passwordController,
              obscureText: true,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(24.0))),
              )),
          SizedBox(height: 36.0),
          RaisedButton(
              padding: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Text('Login',
                  style: TextStyle(color: Colors.white), textScaleFactor: 1.2),
              color: Colors.blueGrey,
              onPressed: () {
                loginBloc.login
                    .add([loginController.text, passwordController.text]);
              })
        ],
      ),
    ); //
  }

  Widget _showBadCredentials(bool badCredentials) {
    if (badCredentials) {
      return Padding(padding: EdgeInsets.only(bottom: 24.0),
        child: Text('Bad credentials', style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center));
    } else {
      return Container();
    }
  }
}
