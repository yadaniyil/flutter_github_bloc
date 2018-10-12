import 'package:flutter_github_bloc/api/auth_repo.dart';
import 'package:flutter_github_bloc/api/user_repo.dart';
import 'package:flutter_github_bloc/bloc/bloc_provider.dart';
import 'package:flutter_github_bloc/models/user.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements BlocBase {
  User currentUser;
  AuthRepo repo;
  UserRepo userRepo;

  PublishSubject<User> _userController = PublishSubject<User>();
  Sink<User> get _inUser => _userController.sink;
  Stream<User> get outUser => _userController.stream;


  PublishSubject<User> _actionController = PublishSubject<User>();
  Sink<User> get updateUser => _actionController.sink;


  UserBloc(AuthRepo authRepo, String login) {
    this.repo = authRepo;
    this.userRepo = UserRepo(authRepo, login);
    userRepo.loadUser().then((User user) => _handleUser(user));

    _actionController.listen((user) => _handleUser(user));
  }

  void _handleUser(User user) {
    print(user);
    currentUser = user;
    _inUser.add(user);
  }

  @override
  void dispose() {
    _userController.close();
    _actionController.close();
  }
}