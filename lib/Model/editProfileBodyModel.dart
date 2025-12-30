// To parse this JSON data, do
//
//     final editProfileBodyModel = editProfileBodyModelFromJson(jsonString);

import 'dart:convert';

EditProfileBodyModel editProfileBodyModelFromJson(String str) =>
    EditProfileBodyModel.fromJson(json.decode(str));

String editProfileBodyModelToJson(EditProfileBodyModel data) =>
    json.encode(data.toJson());

class EditProfileBodyModel {
  String name;
  String image;
  String? email;

  EditProfileBodyModel({
    required this.name,
    required this.image,
     this.email,
  });

  factory EditProfileBodyModel.fromJson(Map<String, dynamic> json) =>
      EditProfileBodyModel(
        name: json["name"],
        image: json["image"],
        //email: json['email'],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    //"email": email,
  };
}
