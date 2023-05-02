import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';

import 'package:appwrite/appwrite.dart';
import 'package:delivery_tracker/constants/app_constants.dart';
import 'package:delivery_tracker/models/order_model.dart';
import 'package:delivery_tracker/models/user_model.dart';
import 'package:delivery_tracker/models/vendor_model.dart';
import 'package:delivery_tracker/pages/home.dart';
import 'package:delivery_tracker/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppProvider extends ChangeNotifier {
  Client client = Client();
  late Account account;
  Databases? databases;
  Realtime? realtime;
  RealtimeSubscription? realtimeSubscription;
  List<Vendor>? _vendorItems;
  List<Order>? _orderItems;
  User? _user;

  late bool _isLoading;
  late bool _isError;
  late bool _isButtonDisabled;

  bool get isLoading => _isLoading;
  bool? get isError => _isError;
  bool get isButtonDisabled => _isButtonDisabled;
  User? get user => _user;
  List<Order>? get orderItems => _orderItems;
  List<Vendor>? get vendorItems => _vendorItems;

  AppProvider() {
    _isButtonDisabled = false;
    _isLoading = true;
    _isError = false;
    _user = null;
    initialize();
  }

  initialize() {
    client
      ..setEndpoint(Appconstants.endpoint)
      ..setProject(Appconstants.projectid);
    account = Account(client);
    databases = Databases(client);
    checkUserSignIn();
  }

  checkUserSignIn() async {
    try {
      _user = await _getUseraccountInfo();
    } catch (e) {
      await listVendorDocument();
    }
  }

  checkAccount(context) async {
    try {
      _isButtonDisabled = true;
      _isLoading = true;
      notifyListeners();
      Timer(const Duration(seconds: 5), () {
        _isButtonDisabled = false;
        notifyListeners();
      });
      _user = await _getUseraccountInfo();
    } on AppwriteException catch (e) {
      print(e.message);
      if (e.message == "XMLHttpRequest error.") {
        _isLoading = false;
        notifyListeners();
        // Shows a toast message for five seconds
        Fluttertoast.showToast(
          msg: 'Check Your Internet Connection', fontSize: 20.0,
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          timeInSecForIosWeb: 5,
        );
      }
      if (e.message == "User (role: guests) missing scope (account)") {
        _isLoading = false;
        notifyListeners();
        // return user to the log in page
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  // map user details to the model class created earlier
  Future<User?> _getUseraccountInfo() async {
    final response = await account.get();
    if (response.status == true) {
      final jsondata = jsonEncode(response.toMap());
      final json = jsonDecode(jsondata);
      await listVendorDocument();
      await listOrderDocument();
      await _subscribe();
      _isLoading = false;
      notifyListeners();
      return User.fromJson(json);
    } else {
      return null;
    }
  }

  login(String userEmail, String userPassword, context) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await account.createEmailSession(
          email: userEmail, password: userPassword);
      if (response.current == true) {
        _user = await _getUseraccountInfo();
        _isLoading = false;
        notifyListeners();
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } on AppwriteException catch (e) {
      if (e.message == "XMLHttpRequest error.") {
        _isLoading = false;
        Fluttertoast.showToast(
          msg: 'Check Your Internet Connection', fontSize: 20.0,
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          timeInSecForIosWeb: 5,
        );
        notifyListeners();
      }
      if (e.message ==
          "Invalid credentials. Please check the email and password.") {
        _isLoading = false;
        Fluttertoast.showToast(
          msg: 'Invalid Email or Password', fontSize: 20.0,
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          timeInSecForIosWeb: 5,
        );
        notifyListeners();
      }
      print(e.message);
    }
  }

  signup(
      String userEmail, String userPassword, String userName, context) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await account.create(
          userId: ID.unique(),
          email: userEmail,
          password: userPassword,
          name: userName);
      if (response.status == true) {
        // _user = await _getUseraccountInfo();
        _isLoading = false;
        notifyListeners();
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } on AppwriteException catch (e) {
      print(e.message);
      if (e.message == "XMLHttpRequest error.") {
        _isLoading = false;
        Fluttertoast.showToast(
          msg: 'Check Your Internet Connection', fontSize: 20.0,
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          timeInSecForIosWeb: 5,
        );
        notifyListeners();
      }
      if (e.message ==
          "A user with the same email already exists in your project.") {
        _isLoading = false;
        Fluttertoast.showToast(
          msg: 'A user already exists with that email', fontSize: 20.0,
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          timeInSecForIosWeb: 5,
        );
        notifyListeners();
      }
    }
  }

  listVendorDocument() async {
    try {
      final response = await databases!.listDocuments(
          databaseId: Appconstants.databaseID,
          collectionId: Appconstants.vendorcollectionID);
      print(response.toMap());
      _vendorItems = response.documents
          .map((vendors) => Vendor.fromJson(vendors.data))
          .toList();
      print(vendorItems);
      if (_vendorItems!.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  listOrderDocument() async {
    try {
      final response = await databases!.listDocuments(
          databaseId: Appconstants.databaseID,
          collectionId: Appconstants.ordercollectionID);
      _orderItems = response.documents
          .map((orders) => Order.fromJson(orders.data))
          .toList();
      print(response.toMap());
    } catch (e) {
      print(e);
    }
  }

  createOrderDocument(
      context, String vendorName, List<String> foodItems) async {
    try {
      _isLoading = true;
      notifyListeners();
      DateTime now = DateTime.now();
      String orderTime = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);

      final result = await databases!.createDocument(
        databaseId: Appconstants.databaseID,
        collectionId: Appconstants.ordercollectionID,
        documentId: ID.unique(),
        data: {
          'vendorName': vendorName,
          'orderTime': orderTime,
          'foodItems': foodItems,
          'delivery': {
            'deliveryTime': '',
          },
        },
      );
      if (result.$id.isNotEmpty) {
        _isLoading = false;
        _isError = false; // success
        Fluttertoast.showToast(
          msg: 'Order Created', fontSize: 20.0,
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          timeInSecForIosWeb: 5,
        );
        notifyListeners();
        listOrderDocument();
        Navigator.pop(context);
      }
    } catch (e) {
      _isLoading = false;
      _isError = true; // failure
      print(e);
      Fluttertoast.showToast(
        msg: 'Failed to create order. Try again', fontSize: 20.0,
        toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
        timeInSecForIosWeb: 5,
      );
      notifyListeners();
    }
  }

  updateOrderDocument(String otherdocumentID, String status, documentID) async {
    try {
      _isLoading == true;
      notifyListeners();
      DateTime now = DateTime.now();
      String orderTime = DateFormat('yyyy-MM-dd – kk:mm').format(now);

      final result = await databases!.updateDocument(
          databaseId: Appconstants.databaseID,
          collectionId: "delivery",
          documentId: documentID,
          data: {
            "OrderID": otherdocumentID,
            "deliveryTime": orderTime,
            "deliveryStatus": status
          });
      await listOrderDocument();
      _isLoading = false;
      notifyListeners();
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  cancelorder(String orderdocumentID, String deliverystatus,
      String orderstatus, String deliverydocumentID) async{
    try {
      DateTime now = DateTime.now();
      String orderTime = DateFormat('yyyy-MM-dd – kk:mm').format(now);

      await databases!.updateDocument(
          databaseId: Appconstants.databaseID,
          collectionId: "delivery",
          documentId: deliverydocumentID,
          data: {
            "OrderID": orderdocumentID,
            "deliveryTime": orderTime,
            "deliveryStatus": deliverystatus
          }).then(
        (value) async {
          if (true) {
            await databases!.updateDocument(
                databaseId: Appconstants.databaseID,
                collectionId: Appconstants.ordercollectionID,
                documentId: orderdocumentID,
                data: {
                  'orderTime': orderTime,
                  'orderStatus': orderstatus,
                  'delivery': deliverydocumentID
                });
            await listOrderDocument();
            notifyListeners();
          }
        },
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "payment-accepted":
        return 0xffAEAEB2;
      case "packed":
        return 0xffD9D9F4;
      case "in-transit":
        return 0xFFFFA500;
      case "delivered":
        return 0xff92EAA8;
      case "canceled":
        return 0xFFFF0000;
      default:
        return 0xffAEAEB2;
    }
  }

  getDeliveryStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "in-progress":
        return 0xFFFFA500;
      case "completed":
        return 0xff92EAA8;
      case "failed":
        return 0xFFFF0000;
      default:
        return 0xffAEAEB2;
    }
  }

  _subscribe() {
    try {
      final realtime = Realtime(client);
      realtimeSubscription = realtime.subscribe([
        'databases.${Appconstants.databaseID}.collections.${Appconstants.ordercollectionID}.documents',
      ]);
      realtimeSubscription?.stream.listen((event) {
        if (event.events.contains(
            'databases.${Appconstants.databaseID}.collections.${Appconstants.ordercollectionID}.documents.*.update')) {
          orderItems?.map((element) {
            if (element.id == event.payload['\$id']) {
              element.orderStatus = event.payload['orderStatus'];
            }
          }).toList();
          notifyListeners();
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
