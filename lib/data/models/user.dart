class User {
  final int? id;
  final String username;
  final String? password;
  final String? email;
  final String? phoneNumber;

  User({
    this.id,
    required this.username,
    this.password,
    this.email,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic>  json){
    return User(
        id: json['id'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        phoneNumber: json['phoneNumber']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'username': username,
      'password': password,
      'email':email,
      'phoneNumber':phoneNumber
    };
  }
}