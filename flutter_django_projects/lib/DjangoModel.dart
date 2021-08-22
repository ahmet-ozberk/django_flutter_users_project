import 'dart:convert';

DjangoModel djangoModelFromJson(String str) => DjangoModel.fromJson(json.decode(str));

class DjangoModel {
  bool? status;
  List<Users>? users;

  DjangoModel({this.status, this.users});

  factory DjangoModel.fromJson(Map<String, dynamic> json) => DjangoModel(
    status: json['status'],
    users: List<Users>.from(json["users"].map((x) => Users.fromJson(x))),
  );
}

class Users {
  int? id;
  String? name;
  String? lastName;
  String? age;
  String? university;
  String? job;

  Users(
      {this.id, this.name, this.lastName, this.age, this.university, this.job});

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json['id'],
    name : json['name'],
    lastName : json['last_name'],
    age : json['age'],
    university : json['university'],
    job : json['job'],
  );
}
