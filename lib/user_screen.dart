import 'package:flutter/material.dart';
import 'package:flutter_github_bloc/bloc/bloc_provider.dart';
import 'package:flutter_github_bloc/bloc/login_bloc.dart';
import 'package:flutter_github_bloc/bloc/user_bloc.dart';
import 'package:flutter_github_bloc/models/user.dart';
import 'package:flutter_github_bloc/widgets/loading_indicator.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('User info'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () => loginBloc.logout.add(null))
          ],
        ),
        body: StreamBuilder<User>(
            stream: userBloc.outUser,
            initialData: null,
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.data == null) {
                return LoadingIndicator();
              } else {
                return getUserView(snapshot.data);
              }
            }));
  }

  Widget getUserView(User user) {
    var dateTime = DateTime.parse(user.createdAt).toLocal();
    return ListView(
      children: <Widget>[
        SizedBox(height: 24.0),
        ListTile(
            leading: Image.network(user.avatarUrl, width: 70.0, height: 70.0),
            title: Text(user.name, textScaleFactor: 1.2),
            subtitle: Text(user.login, textScaleFactor: 1.2)),
        SizedBox(height: 24.0),
        Row(children: <Widget>[
          Expanded(
            flex: 1,
            child: Text('Folowing (${user.following})',
                textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: Text('Followers (${user.followers})',
                textAlign: TextAlign.center),
          )
        ]),
        SizedBox(height: 12.0),
        Divider(),
        ListTile(leading: Icon(Icons.location_on), title: Text(user.location)),
        Divider(),
        ListTile(
          leading: Icon(Icons.access_time),
          title: Text('Created at'),
          subtitle: Text(
              '${formatDateUnit(dateTime.day)}/${formatDateUnit(dateTime.month)}/${dateTime.year}'),
        ),
        Divider(),
      ],
    );
  }

  String formatDateUnit(int unit) {
    var formattedDate = unit.toString();
    if (formattedDate.length == 1) {
      return '0' + formattedDate;
    } else {
      return formattedDate;
    }
  }
}
