class FilterCondition {
  late String property;
  late String value;
  late String condition;

  FilterCondition({
    required this.property,
    required this.value,
    required this.condition,
  });

  Map<String, dynamic> toJson() {
    return {
      'property': property,
      'value': value,
      'condition': condition,
    };
  }
}
