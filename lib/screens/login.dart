import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:hotelmgm/api.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginPage extends StatelessWidget {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint(
        'Signup: ${data.name}, ${data.password}, ${data.additionalSignupData},');
    return registerUser(
      data.additionalSignupData!["Name"]!,
      data.additionalSignupData!["Surname"]!,
      data.name!,
      data.additionalSignupData!["Username"]!,
      data.password!
    );
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then(
      (_) {
        if (!users.containsKey(name)) {
          return 'User not exists';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Hotel Mgm',
      logo: 'images/umbra.png',
      additionalSignupFields: const [
        UserFormField(keyName: 'Username', icon: Icon(Icons.person)),
        UserFormField(keyName: 'Name', icon: Icon(Icons.abc)),
        UserFormField(keyName: 'Surname', icon: Icon(Icons.badge)),
      ],
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        // Navigate to the home screen after successful login/signup
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
