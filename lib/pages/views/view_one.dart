import 'package:delivery_tracker/auth/app_provider.dart';
import 'package:delivery_tracker/pages/component/registrationloader.dart';
import 'package:delivery_tracker/pages/views/modal/view_one_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = ScrollController();
  final happyHourcontroller = ScrollController();
  int selectedIndex = -1;
  int featureselectedIndex = -1;
  int happyhourselectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, state, child) {
      return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  child: Scrollbar(
                    thickness: 10,
                    thumbVisibility: false,
                    trackVisibility: false,
                    interactive: true,
                    controller: controller,
                    radius: const Radius.circular(15),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      controller: controller,
                      itemCount: state.vendorItems != null ? state.vendorItems!.length : 5,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        return buildCard(index, selectedIndex == index, state.vendorItems);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 12,
                        );
                      },
                    ),
                  ),
                ),
                const Text(
                  "Featured Vendor",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 10,
                ),
                featuredCard(0, featureselectedIndex == 0),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 8.0)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Happy Hour",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 150,
                  child: Scrollbar(
                    thickness: 10,
                    thumbVisibility: false,
                    trackVisibility: false,
                    interactive: true,
                    controller: happyHourcontroller,
                    radius: const Radius.circular(15),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      controller: happyHourcontroller,
                      itemCount: 8,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        return happyHourCard(
                            index, happyhourselectedIndex == index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 12,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    },);
  }

  Widget buildCard(int index, bool isSelected, vendorItems) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() {
        selectedIndex = index;
      }),
      onExit: (event) => setState(() {
        selectedIndex = -1;
      }),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Return the dialog widget
              return EditListItemDialog(
                item: vendorItems![index],
              );
            },
          );
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: vendorItems != null ? Text("${vendorItems![index].name}") : registrationloader() ,
          ),
        ),
      ),
    );
  }

  Widget featuredCard(int index, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() {
        featureselectedIndex = index;
      }),
      onExit: (event) => setState(() {
        featureselectedIndex = -1;
      }),
      child: InkWell(
        onTap: () {
          setState(() {
            featureselectedIndex = index;
          });
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text("${index + 1}"),
          ),
        ),
      ),
    );
  }

  Widget happyHourCard(int index, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() {
        happyhourselectedIndex = index;
      }),
      onExit: (event) => setState(() {
        happyhourselectedIndex = -1;
      }),
      child: InkWell(
        onTap: () {
          setState(() {
            happyhourselectedIndex = index;
          });
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text("${index + 1}"),
          ),
        ),
      ),
    );
  }
}

class Mockdata {
  String? title;
  String? subtitle;
  Mockdata({this.title, this.subtitle});
}
