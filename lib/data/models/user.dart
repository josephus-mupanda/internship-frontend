class User {
  final String username;
  final String password;
  final String email;
  final String phoneNumber;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic>  json){
    return User(
        username: json['username'],
        password: json['password'],
        email: json['email'],
        phoneNumber: json['phoneNumber']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'username': username,
      'password': password,
      'email':email,
      'phoneNumber':phoneNumber
    };
  }
}