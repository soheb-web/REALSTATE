// To parse this JSON data, do
//
//     final homeGetServiceCategoryModel = homeGetServiceCategoryModelFromJson(jsonString);

import 'dart:convert';

HomeGetServiceCategoryModel homeGetServiceCategoryModelFromJson(String str) => HomeGetServiceCategoryModel.fromJson(json.decode(str));

String homeGetServiceCategoryModelToJson(HomeGetServiceCategoryModel data) => json.encode(data.toJson());

class HomeGetServiceCategoryModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    HomeGetServiceCategoryModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory HomeGetServiceCategoryModel.fromJson(Map<String, dynamic> json) => HomeGetServiceCategoryModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "error": error,
        "data": data?.toJson(),
    };
}

class Data {
    List<ListElement>? list;
    int? total;

    Data({
        this.list,
        this.total,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
        "total": total,
    };
}

class ListElement {
    String? id;
    String? name;
    String? image;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;

    ListElement({
        this.id,
        this.name,
        this.image,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
    });

    factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}
