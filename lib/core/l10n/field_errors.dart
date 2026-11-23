import '../utils/validators.dart';
import 'l10n.dart';

String? fieldErrorText(FieldError? error, AppLocalizations l10n) {
  if (error == null) return null;
  return switch (error) {
    FieldError.required => l10n.requiredField,
    FieldError.invalidPhone => l10n.invalidPhone,
    FieldError.invalidOtp => 'Enter the 6-digit code',
    FieldError.invalidNumber => 'Enter a valid number',
    FieldError.negativeNumber => 'Enter a positive number',
    FieldError.invalidYear => l10n.invalidYear,
    FieldError.invalidToken => 'Check the token and try again',
    FieldError.tooLong => 'That value is too long',
    FieldError.tooShort => 'That value is too short',
  };
}
