import 'package:flutter/material.dart';

class Vendor {
  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final List<FoodType> foodTypes;

  Vendor({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.foodTypes,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['\$id'],
      name: json['name'],
      createdAt: json['\$createdAt'],
      updatedAt: json['\$updatedAt'],
      foodTypes: (json['foodTypes'] as List<dynamic>)
          .map((e) => FoodType.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'vendors': name,
      '\$createdAt': createdAt,
      '\$updatedAt': updatedAt,
      'foodtype': foodTypes.map((e) => e.toJson()).toList(),
    };
  }
}

class FoodType {
  final String id;
  final String name;
  final List<String> foodname;
  final List<bool> foodnameChecked;
  GlobalKey? key;
  final String createdAt;
  final String updatedAt;

  FoodType({
    required this.id,
    required this.name,
    required this.foodname,
    required this.foodnameChecked,
    this.key,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodType.fromJson(Map<String, dynamic> json) {
    return FoodType(
      id: json['\$id'],
      name: json['foodtype'],
      foodname: List<String>.from(json['food']),
      foodnameChecked: List<bool>.from(json['foodChecked']),
      key: GlobalKey(),
      createdAt: json['\$createdAt'],
      updatedAt: json['\$updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$id': id,
      'foodtype': name,
      'food': foodname,
      'foodChecked': foodnameChecked,
      '\$createdAt': createdAt,
      '\$updatedAt': updatedAt,
    };
  }
}
