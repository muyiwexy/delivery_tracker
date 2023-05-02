import 'package:delivery_tracker/auth/app_provider.dart';
import 'package:delivery_tracker/models/vendor_model.dart';
import 'package:delivery_tracker/pages/component/registrationloader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditListItemDialog extends StatefulWidget {
  final Vendor item;

  const EditListItemDialog({Key? key, required this.item}) : super(key: key);

  @override
  _EditListItemDialogState createState() => _EditListItemDialogState();
}

class _EditListItemDialogState extends State<EditListItemDialog> {
  final key1 = GlobalKey();
  final controller = ScrollController();
  int selectedIndex = 0;
  List<String> checkedItems = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 4.0)),
              ),
            ),
            SizedBox(
              height: 50,
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
                  itemCount: widget.item.foodTypes.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    return modalbuildCard(
                        index, selectedIndex == index, widget.item);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 12,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: widget.item.foodTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.foodTypes[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Column(
                            children: List.generate(
                                widget.item.foodTypes[index].foodname.length,
                                (subIndex) {
                              final item = widget.item.foodTypes[index];
                              return CheckboxListTile(
                                title: Text(item.foodname[subIndex]),
                                value: item.foodnameChecked[subIndex],
                                onChanged: (bool? value) {
                                  setState(() {
                                    item.foodnameChecked[subIndex] = value!;
                                    if (item.foodnameChecked[subIndex] ==
                                        true) {
                                      checkedItems.add(item.foodname[subIndex]);
                                    } else {
                                      checkedItems.removeWhere((items) =>
                                          items == item.foodname[subIndex]);
                                    }
                                  });
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Consumer<AppProvider>(
          builder: (context, state, child) {
            return TextButton(
              onPressed: state.isButtonDisabled
                  ? null
                  : () async {
                      if (checkedItems.isEmpty) {
                      } else {
                        await state.checkAccount(context);
                        if (mounted) {
                          await state.createOrderDocument(
                              context, widget.item.name, checkedItems);
                        }
                      }
                    },
              child: state.isLoading == true
                  ? registrationloader()
                  : const Text('Create Order'),
            );
          },
        )
      ],
    );
  }

  Widget modalbuildCard(int index, bool isSelected, item) {
    return SizedBox(
      width: 150, // set the width of the SizedBox to 200
      height: 100, // set the height of the SizedBox to 50
      child: TextButton(
          onPressed: () {
            setState(() {
              selectedIndex = index;
            });
            // Scrollable.ensureVisible(widget.item.foodTypes[index].key.currentContext!);
          },
          child: Text(
            item.foodTypes[index].name,
            style: TextStyle(
              color: isSelected ? Colors.blueAccent : Colors.blueGrey,
            ),
          )),
    );
  }
}

class Modaldata {
  String? title;
  List<bool>? check;
  GlobalKey? key;
  List<String>? subitems;
  Modaldata({this.title, this.check, this.key, this.subitems});
}
