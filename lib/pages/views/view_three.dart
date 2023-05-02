import 'package:delivery_tracker/auth/app_provider.dart';
import 'package:delivery_tracker/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, state, child) {
        if (state.orderItems != null && state.orderItems!.isNotEmpty) {
          return ListView.builder(
            itemCount: state.orderItems!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.orderItems![index].vendorName!),
                subtitle: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: state.orderItems![index].orderStatus!,
                          style: TextStyle(
                            color: Color(state.getOrderStatusColor(
                                state.orderItems![index].orderStatus!)),
                            fontWeight: FontWeight.bold,
                          )),
                      const TextSpan(
                          text: '  .  ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                      TextSpan(
                          text: state.orderItems![index].orderTime,
                          style: const TextStyle(
                            color: Color.fromARGB(
                              255,
                              0,
                              35,
                              65,
                            ),
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ChangeNotifierProvider.value(
                        value: context.read<AppProvider>(),
                        child: ShowOrder(index: index),
                      );
                    },
                  );
                },
              );
            },
          );
        } else {
          return const Center(
              child:
                  Text("No order avaialable", style: TextStyle(fontSize: 20)));
        }
      },
    );
  }
}

class ShowOrder extends StatefulWidget {
  // final Order orderlist;
  final int index;
  const ShowOrder({super.key, required this.index});

  @override
  State<ShowOrder> createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, state, child) {
        return AlertDialog(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "Order Details",
              style: TextStyle(fontSize: 25),
            ),
            if (state.orderItems![widget.index].orderStatus == "delivered" ||
                state.orderItems![widget.index].orderStatus == "canceled" ||
                state.orderItems![widget.index].delivery!.deliveryStatus ==
                    "completed" ||
                state.orderItems![widget.index].delivery!.deliveryStatus ==
                    "failed")
              Container()
            else
              ElevatedButton(
                  onPressed: () {
                    state.cancelorder(
                        state.orderItems![widget.index].id!,
                        "failed",
                        "canceled",
                        state.orderItems![widget.index].delivery!.$id!);
                    print(state
                        .orderItems![widget.index].delivery!.deliveryStatus!);
                  },
                  child: const Text("Cancel Order"))
          ]),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.orderItems![widget.index].foodItems!.length,
                  itemBuilder: (context, index) {
                    if (state.orderItems![widget.index].foodItems!.isNotEmpty) {
                      return ListTile(
                        title: Text(
                            state.orderItems![widget.index].foodItems![index]),
                      );
                    }
                    return null;
                  },
                ),
              ),
              if (state.orderItems![widget.index].orderStatus == "delivered" &&
                  state.orderItems![widget.index].delivery!.deliveryStatus ==
                      "in-progress")
                ListTile(
                  title: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Have you recieved your package",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          if (state.orderItems![widget.index].orderStatus ==
                              "delivered") {
                            state.updateOrderDocument(
                                state.orderItems![widget.index].id!,
                                "completed",
                                state.orderItems![widget.index].delivery!.$id);
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        child: const Text('No'),
                        onPressed: () {
                          if (state.orderItems![widget.index].orderStatus ==
                              "delivered") {
                            state.updateOrderDocument(
                                state.orderItems![widget.index].id!,
                                "failed",
                                state.orderItems![widget.index].delivery!.$id);
                          }
                        },
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      state.orderItems![widget.index].delivery!.deliveryStatus!,
                      style: TextStyle(
                          color: Color(state.getDeliveryStatusColor(state
                              .orderItems![widget.index]
                              .delivery!
                              .deliveryStatus!)),
                          fontSize: 20.0),
                    ),
                  ),
                )
            ]),
          ),
        );
      },
    );
  }
}
