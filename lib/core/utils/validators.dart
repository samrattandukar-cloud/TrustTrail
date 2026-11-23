/// Validation returns a typed error so screens can localise the message.
enum FieldError {
  required,
  invalidPhone,
  invalidOtp,
  invalidNumber,
  negativeNumber,
  invalidYear,
  invalidToken,
  tooLong,
  tooShort,
}

abstract final class Validators {
  static final _phoneShape = RegExp(r'^(?:\+?977)?9[678]\d{8}$');
  static final _otpShape = RegExp(r'^\d{6}$');
  static final _plateShape = RegExp(
    r'^[A-Z]{1,3}[ -]?\d{1,2}[ -]?[A-Z]{1,3}[ -]?\d{1,4}$',
  );

  static FieldError? requiredText(String? value, {int minLength = 1}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return FieldError.required;
    if (text.length < minLength) return FieldError.tooShort;
    return null;
  }

  static FieldError? phone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'[\s-]'), '');
    if (digits.isEmpty) return FieldError.required;
    return _phoneShape.hasMatch(digits) ? null : FieldError.invalidPhone;
  }

  static FieldError? otp(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return FieldError.required;
    return _otpShape.hasMatch(text) ? null : FieldError.invalidOtp;
  }

  static FieldError? positiveInt(String? value, {bool allowZero = false}) {
    final text = (value ?? '').trim().replaceAll(',', '');
    if (text.isEmpty) return FieldError.required;
    final parsed = int.tryParse(text);
    if (parsed == null) return FieldError.invalidNumber;
    if (allowZero ? parsed < 0 : parsed <= 0) return FieldError.negativeNumber;
    return null;
  }

  static FieldError? year(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return FieldError.required;
    final parsed = int.tryParse(text);
    if (parsed == null) return FieldError.invalidNumber;
    final maxYear = DateTime.now().year + 1;
    if (parsed < 1960 || parsed > maxYear) return FieldError.invalidYear;
    return null;
  }

  static FieldError? plate(String? value) {
    final text = (value ?? '').trim().toUpperCase().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    if (text.isEmpty) return FieldError.required;
    return _plateShape.hasMatch(text) ? null : FieldError.invalidNumber;
  }

  static FieldError? maxLength(String? value, int max) {
    final text = value?.trim() ?? '';
    return text.length > max ? FieldError.tooLong : null;
  }
}
