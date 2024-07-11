// class LoginResponse {
//   LoginResponse({
//     required this.message,
//     required this.data
//   });

//   late final String message;
//   late final String data;

//   LoginResponse.fromJson(Map<String, dynamic> json){
//     message = json['message'];
//     data = Data.fromJson(json['data']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic> {};
//     _data['message'] = message;
//     _data['data'] = data.toJson();

//     return _data;
//   }
// }

// class Data {
//   Data({
//     required this.email,
//     required this.password
//   });

//   late final String email;
//   late final String password;
// }

