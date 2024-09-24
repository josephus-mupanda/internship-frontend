
class Environment {

  static const String baseUrl = 'http://localhost:8080'; //'http://192.168.97.102:8080';

  //Define Header Constants
  static Map<String, String> getJsonHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static const String fontFamily = 'Poppins';

}
