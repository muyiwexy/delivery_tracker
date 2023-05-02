import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// import 'package:delivery_tracker/auth/app_provider.dart';
// import 'package:delivery_tracker/models/order_model.dart';
// import 'package:delivery_tracker/pages/component/registrationloader.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class OrderView extends StatefulWidget {
//   const OrderView({super.key});

//   @override
//   State<OrderView> createState() => _OrderViewState();
// }

// class _OrderViewState extends State<OrderView> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppProvider>(
//       builder: (context, state, child) {
//         if (state.orderItems != null && state.orderItems!.isNotEmpty) {
//           return ListView.builder(
//             itemCount: state.orderItems!.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(state.orderItems![index].vendorName!),
//                 subtitle: RichText(
//                   text: TextSpan(
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: state.orderItems![index].orderStatus!,
//                           style: TextStyle(
//                             color: Color(state.getOrderStatusColor(
//                                 state.orderItems![index].orderStatus!)),
//                             fontWeight: FontWeight.bold,
//                           )),
//                       const TextSpan(
//                           text: '  .  ',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 25)),
//                       TextSpan(
//                           text: state.orderItems![index].orderTime,
//                           style: const TextStyle(
//                             color: Color.fromARGB(
//                               255,
//                               0,
//                               35,
//                               65,
//                             ),
//                             fontWeight: FontWeight.bold,
//                           )),
//                     ],
//                   ),
//                 ),
//                 trailing: const Icon(Icons.arrow_forward_ios),
//                 onTap: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     builder: (context) {
//                       return ShowOrder(orderlist: state.orderItems![index]);
//                     },
//                   );
//                   // showDialog(
//                   //   context: context,
//                   //   builder: (context) {
//                   //     return ShowOrder(orderlist: state.orderItems![index]);
//                   //   },
//                   // );
//                 },
//               );
//             },
//           );
//         } else {
//           return const Center(
//               child:
//                   Text("No order avaialable", style: TextStyle(fontSize: 20)));
//         }
//       },
//     );
//   }
// }

// class ShowOrder extends StatelessWidget {
//   final Order orderlist;

//   const ShowOrder({Key? key, required this.orderlist}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final appProvider = Provider.of<AppProvider>(context, listen: false);

//     return Container(
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                   child: Container(
//                 child: Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(Icons.close)),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Text(
//                       "Order Details",
//                       style: TextStyle(fontSize: 25),
//                     ),
//                   ],
//                 ),
//               )),
//               if (canCancelOrder(orderlist))
//                 ElevatedButton(
//                   onPressed: () {
//                     appProvider.cancelorder(
//                       orderlist.id!,
//                       "failed",
//                       "canceled",
//                       orderlist.delivery!.$id!,
//                     );
//                   },
//                   child: Text("Cancel Order"),
//                 ),
//             ],
//           ),
//           SizedBox(height: 10.0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: orderlist.foodItems!.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(orderlist.foodItems![index]),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 10.0),
//           buildDeliveryStatus(context, appProvider),
//           SizedBox(height: 10.0),
//           buildDeliveryActions(context, appProvider, orderlist),
//         ],
//       ),
//     );
//   }

//   bool canCancelOrder(Order order) {
//     return order.orderStatus == "pending" ||
//         order.orderStatus == "accepted" ||
//         order.delivery!.deliveryStatus == "in-progress";
//   }

//   Widget buildDeliveryStatus(BuildContext context, AppProvider appProvider) {
//     final deliveryStatus = orderlist.delivery!.deliveryStatus!;
//     final color = Color(appProvider.getDeliveryStatusColor(deliveryStatus));

//     return Container(
//       padding: EdgeInsets.all(10.0),
//       color: color.withOpacity(0.2),
//       child: Center(
//         child: Text(
//           deliveryStatus,
//           style: TextStyle(color: color, fontSize: 20.0),
//         ),
//       ),
//     );
//   }

//   Widget buildDeliveryActions(
//     BuildContext context,
//     AppProvider appProvider,
//     Order order,
//   ) {
//     if (order.orderStatus != "delivered" ||
//         order.delivery!.deliveryStatus != "in-progress") {
//       return Container();
//     }

//     if (appProvider.isLoading == true) {
//       return registrationloader();
//     } else {
//       return ListTile(
//         title: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Text(
//             "Have you received your package?",
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               child: const Text('Yes'),
//               onPressed: () {
//                 appProvider.updateOrderDocument(
//                   order.id!,
//                   "completed",
//                   order.delivery!.$id!,
//                 );
//               },
//             ),
//             const SizedBox(width: 10),
//             ElevatedButton(
//               child: const Text('No'),
//               onPressed: () {
//                 appProvider.updateOrderDocument(
//                   order.id!,
//                   "failed",
//                   order.delivery!.$id!,
//                 );
//               },
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
