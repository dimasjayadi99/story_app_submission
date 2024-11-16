class LoginModel {
  final bool error;
  final String message;
  final LoginResult loginResult;

  LoginModel(
      {required this.error, required this.message, required this.loginResult});

  factory LoginModel.fromJson(Map<String, dynamic> map) {
    return LoginModel(
      error: map['error'],
      message: map['message'],
      loginResult: LoginResult.fromJson(map['loginResult']),
    );
  }
}

class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> map) {
    return LoginResult(
        userId: map['userId'], name: map['name'], token: map['token']);
  }
}
