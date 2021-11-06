// To parse this JSON data, do
//
//     final taskyManagerApi = taskyManagerApiFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

TaskyManagerApi taskyManagerApiFromJson(String str) => TaskyManagerApi.fromJson(json.decode(str));

String taskyManagerApiToJson(TaskyManagerApi data) => json.encode(data.toJson());

class TaskyManagerApi {
    TaskyManagerApi({
        this.message,
        this.data,
    });

    String? message;
    List<Datum>? data;

    factory TaskyManagerApi.fromJson(Map<String, dynamic> json) => TaskyManagerApi(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.title,
        required this.description,
        required this.isCompleted,
        required this.v,
    });

    String id;
    String title;
    String description;
    bool isCompleted;
    int v;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        isCompleted: json["isCompleted"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "isCompleted": isCompleted,
        "__v": v,
    };
}
