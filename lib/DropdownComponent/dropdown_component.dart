import 'package:flutter/material.dart';
import 'package:multi_select_dropdown/DropdownComponent/item.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class DropdownComponent extends StatefulWidget {
  const DropdownComponent({super.key});

  @override
  State<DropdownComponent> createState() => _DropdownComponentState();
}

class _DropdownComponentState extends State<DropdownComponent> {
  List<ItemModel> _items = [];
  List<ItemModel> _selectedItems = [];
  bool isOpen = false;
  bool changeData = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _fetchData() async {
    final String response =
        await rootBundle.loadString('assets/fake_data.json');
    final data = await json.decode(response);
    final List<ItemModel> _list = (data['list'] as List<dynamic>)
        .map((e) => ItemModel.fromJson(e))
        .toList();
    _items = _list;
  }

  void _getData() async {
    await _fetchData();
  }

  void _selectItem(ItemModel itemModel, ItemModel parent) {
    int _selectSub = 0;
    setState(() {
      itemModel.selected = true;
      for (ItemModel sub in itemModel.subItem) {
        sub.selected = true;
      }
      _selectedItems.add(itemModel);

      if (itemModel != parent) {
        for (ItemModel sub in parent.subItem) {
          if (sub.selected) {
            _selectSub += 1;
          }
        }
        if (_selectSub == parent.subItem.length) {
          parent.selected = true;
          _selectedItems.add(parent);
          for (ItemModel sub in parent.subItem) {
            _selectedItems.remove(sub);
          }
        }
        for (ItemModel sub in itemModel.subItem) {
          sub.selected = true;
        }
      }
    });
  }

  void _unselectItem(ItemModel itemModel, {ItemModel? parent}) {
    int _selectSub = 0;
    setState(() {
      itemModel.selected = false;
      for (ItemModel sub in itemModel.subItem) {
        sub.selected = false;
      }
      _selectedItems.remove(itemModel);
      if (itemModel != parent && parent != null) {
        parent.selected = false;
        _selectedItems.remove(parent);

        for (ItemModel sub in parent.subItem) {
          if (sub.selected) {
            if (!_selectedItems.contains(sub)) {
              _selectedItems.add(sub);
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Dropdown Component",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 32, bottom: 6),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.background,
                        boxShadow: [
                          if (MediaQuery.of(context).viewInsets.bottom != 0 ||
                              isOpen)
                            BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                offset: const Offset(0, 0),
                                blurRadius: 3),
                        ],
                        border: Border.all(
                            width: 1,
                            color: (MediaQuery.of(context).viewInsets.bottom ==
                                        0 &&
                                    !isOpen)
                                ? Theme.of(context).dividerColor
                                : Theme.of(context).primaryColor)),
                    child: Center(
                      child: TextFormField(
                        controller: _controller,
                        cursorWidth: 1,
                        cursorColor: Colors.black54,
                        textInputAction: TextInputAction.newline,
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            setState(() {
                              changeData = true;
                            });
                          } else {
                            setState(() {
                              changeData = false;
                              isOpen = true;
                              if (_selectedItems.isNotEmpty) {
                                _unselectItem(
                                    _selectedItems[_selectedItems.length - 1]);
                                _controller.text = ' ';
                              }
                            });
                          }
                        },
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        minLines: 1,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 0),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: Icon(
                              isOpen
                                  ? Icons.search_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            prefix: Wrap(
                              children: _selectedItems
                                  .map((e) => _itemWidget(e))
                                  .toList(),
                            ),
                            hintText: _selectedItems.isNotEmpty
                                ? ''
                                : "Please select",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Theme.of(context).hintColor)),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                changeData
                    ? Container(
                        height: 100,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  offset: const Offset(0, 0),
                                  blurRadius: 16),
                            ]),
                        child: Center(
                            child: Text("No Data",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color:
                                            Theme.of(context).dividerColor))),
                      )
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        constraints: const BoxConstraints(
                          maxHeight: 280,
                        ),
                        width: double.infinity,
                        height:
                            (_items.isEmpty || !isOpen) ? 0 : double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  offset: const Offset(0, 0),
                                  blurRadius: 16),
                            ]),
                        child: ListView.builder(
                          itemBuilder: (context, index) => _DropdownItemWidget(
                            _items[index],
                            _items[index],
                          ),
                          itemCount: _items.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _DropdownItemWidget(ItemModel item, ItemModel parent) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            (_selectedItems.contains(item) || _selectedItems.contains(parent))
                ? _unselectItem(item, parent: parent)
                : _selectItem(item, parent);
          },
          child: Row(
            children: [
              if (item.subItem.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _items
                              .firstWhere((element) => item.id == element.id)
                              .isOpen =
                          !_items
                              .firstWhere((element) => item.id == element.id)
                              .isOpen;
                    });
                  },
                  child: Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Icon(
                      item.isOpen
                          ? Icons.arrow_drop_down_sharp
                          : Icons.arrow_left_sharp,
                      color: const Color(0xff292929),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  (_selectedItems.contains(item) ||
                          _selectedItems.contains(parent))
                      ? _unselectItem(item, parent: parent)
                      : _selectItem(item, parent);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 8, right: 0, top: 6, bottom: 6),
                  child: _selectedItems.contains(item) || item.selected
                      ? const Icon(Icons.done)
                      : const Icon(Icons.crop_square_rounded),
                ),
              ),
              Text(item.name),
            ],
          ),
        ),
        if (item.isOpen)
          AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) => _DropdownItemWidget(
                  item.subItem[index],
                  parent,
                ),
                itemCount: item.subItem.length,
                shrinkWrap: true,
                primary: false,
              ))
      ],
    );
  }

  Widget _itemWidget(ItemModel itemModel) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.only(left: 4, top: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              itemModel.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            GestureDetector(
              onTap: () {
                _unselectItem(itemModel);
                _controller.clear();
              },
              child: const Icon(
                Icons.close_outlined,
                size: 18,
                color: Color(0xff9a9a9a),
              ),
            )
          ],
        ),
      ),
    );
  }
}
