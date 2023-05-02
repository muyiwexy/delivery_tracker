class Fields {
  static const String vendorName = "vendorName";
  static const String orderStatus = "orderStatus";
  static const String orderTime = "orderTime";
  static const String foodItems = "foodItems";
  static const String delivery = "delivery";
}

class Order {
  String ? id;
  String? vendorName;
  String? orderStatus;
  String? orderTime;
  List<String>? foodItems;
  MealEntry? delivery;

  Order({
    this.id,
    this.vendorName,
    this.orderStatus,
    this.orderTime,
    this.foodItems,
    this.delivery,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['\$id'];
    vendorName = json[Fields.vendorName];
    orderStatus = json[Fields.orderStatus];
    orderTime = json[Fields.orderTime];
    foodItems = List<String>.from(json[Fields.foodItems]);
    delivery = MealEntry.fromJson(json[Fields.delivery]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["\$id"] = id;
    data[Fields.vendorName] = vendorName;
    data[Fields.orderStatus] = orderStatus;
    data[Fields.orderTime] = orderTime;
    data[Fields.foodItems] = foodItems;
    data[Fields.delivery] = delivery!.toJson();
    return data;
  }
}

class MealEntry {
  String? $id;
  String? deliveryStatus;
  String? deliveryTime;
  MealEntry({this.$id, required this.deliveryStatus, this.deliveryTime});
  MealEntry.fromJson(Map<String, dynamic> json) {
    deliveryTime = json["deliveryTime"];
    $id = json["\$id"];
    deliveryStatus = json["deliveryStatus"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["deliveryTime"] = deliveryTime;
    data["deliveryStatus"] = deliveryStatus;
    return data;
  }
}
