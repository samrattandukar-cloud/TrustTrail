import 'package:flutter/widgets.dart';

abstract final class TtRadius {
  static const card = 16.0;
  static const button = 14.0;
  static const field = 12.0;
  static const sheet = 28.0;
  static const pill = 999.0;

  static const cardBorder = BorderRadius.all(Radius.circular(card));
  static const buttonBorder = BorderRadius.all(Radius.circular(button));
  static const fieldBorder = BorderRadius.all(Radius.circular(field));
  static const sheetBorder = BorderRadius.vertical(top: Radius.circular(sheet));
  static const pillBorder = BorderRadius.all(Radius.circular(pill));
}
