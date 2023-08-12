import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ItemModel {
  final int id;
  final String name;
  bool _selected = false;

  bool get selected => _selected;

  set selected(value) {
    _selected = value;
  }

  bool _isOpen = false;

  bool get isOpen => _isOpen;

  set isOpen(value) {
    _isOpen = value;
  }

  final List<ItemModel> subItem;

  ItemModel(this.id, this.name, this.subItem);

  @override
  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
}
