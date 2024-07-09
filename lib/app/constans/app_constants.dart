library app_constants;

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

part 'api_path.dart';
part 'assets_path.dart';

const kFontColorPallets = [
  Color.fromRGBO(26, 31, 56, 1),
  Color.fromRGBO(72, 76, 99, 1),
  Color.fromRGBO(149, 149, 163, 1),
];
const kBorderRadius = 10.0;
const kSpacing = 20.0;

const types = [
  "1 кімнатна",
  "2 кімнатна",
  "3 кімнатна",
  "4 кімнатна",
  "Студія",
  "Приватний будинок",
  "Частина будинку",
];

const regions = [
  "Галицький",
  "Залізничний",
  "Личаківський",
  "Франківський",
  "Шевченківський",
  "Сихівський",
];

var rolesOfClient = [
  "Передзвонити",
  "Зустріч",
  "Оплачено",
  "Заселен",
  "Заморожено",
  "Загальне",
  "Ріелтор"
];

const cities = [
  "Львів",
];

var statuses = ["Active", "Deleted", "Progress"];

const rates = [
  "1 день",
  "Профи",
  "Базовый",
  "Гарант",
];

const tasks = [
  "Встреча",
  "Перезвонить позже",
  "Оплачен",
  "Заселен",
  "Заморожен",
  "Загальні"
];

const rolesOfTheUser = [
  "Stuff",
  "Customer",
];

const roleDefinition = {
  "Stuff" : "Співробітник",
  "Customer" : "Клієнт",
  "Admin": "Адмін"
};

const String taskSelectionMeeting = "Зустріч";
const String taskSelectionCallLater = "Передзвонити пізніше";

final List<MultiSelectItem<String>> regionsItemsMulti = [
  MultiSelectItem<String>('Галицький', 'Галицький'),
  MultiSelectItem<String>('Залізничний', 'Залізничний'),
  MultiSelectItem<String>('Личаківський', 'Личаківський'),
  MultiSelectItem<String>('Франківський', 'Франківський'),
  MultiSelectItem<String>('Шевченківський', 'Шевченківський'),
  MultiSelectItem<String>('Сихівський', 'Сихівський'),
];
final List<MultiSelectItem<String>> typesAppartMulti = [
  MultiSelectItem<String>('1 кімнатна', '1 кімнатна'),
  MultiSelectItem<String>('2 кімнатна', '2 кімнатна'),
  MultiSelectItem<String>('3 кімнатна', '3 кімнатна'),
  MultiSelectItem<String>('4 кімнатна', '4 кімнатна'),
  MultiSelectItem<String>('Студія', 'Студія'),
  MultiSelectItem<String>('Приватний будинок', 'Приватний будинок'),
  MultiSelectItem<String>('Частина будинку', 'Частина будинку'),
];
