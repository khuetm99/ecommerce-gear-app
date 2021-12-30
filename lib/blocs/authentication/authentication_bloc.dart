import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/data/repository/auth_repository/auth_repo.dart';
import 'package:ecommerce_app/data/repository/auth_repository/firebase_auth_repo.dart';


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(Uninitialized());

  final AuthRepository _authRepository = FirebaseAuthRepository();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      bool isLoggedIn = _authRepository.isLoggedIn();

      if (isLoggedIn) {
        // Get current user
        final loggedFirebaseUser = _authRepository.loggedFirebaseUser;
        yield Authenticated(loggedFirebaseUser);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(_authRepository.loggedFirebaseUser);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _authRepository.logOut();
  }
}

