import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/core/utils/validators.dart';

void main() {
  group('phone', () {
    test('accepts local and +977 formats', () {
      expect(Validators.phone('9801234567'), isNull);
      expect(Validators.phone('9779801234567'), isNull);
      expect(Validators.phone('+977 980-123 4567'), isNull);
      expect(Validators.phone(' 9861234567 '), isNull);
    });

    test('rejects short numbers and wrong prefix', () {
      expect(Validators.phone('980123456'), FieldError.invalidPhone);
      expect(Validators.phone('9112345678'), FieldError.invalidPhone);
      expect(Validators.phone('abc'), FieldError.invalidPhone);
    });

    test('reports empty input as required', () {
      expect(Validators.phone('   '), FieldError.required);
    });
  });

  group('otp', () {
    test('accepts exactly six digits', () {
      expect(Validators.otp('123456'), isNull);
    });

    test('rejects wrong length or letters', () {
      expect(Validators.otp('12345'), FieldError.invalidOtp);
      expect(Validators.otp('12345a'), FieldError.invalidOtp);
      expect(Validators.otp(''), FieldError.required);
    });
  });

  group('positiveInt', () {
    test('accepts grouped and plain digits', () {
      expect(Validators.positiveInt('1250'), isNull);
      expect(Validators.positiveInt('1,250'), isNull);
      expect(Validators.positiveInt('0', allowZero: true), isNull);
    });

    test('rejects zero, negatives and words', () {
      expect(Validators.positiveInt('0'), FieldError.negativeNumber);
      expect(Validators.positiveInt('-5'), FieldError.negativeNumber);
      expect(Validators.positiveInt('abc'), FieldError.invalidNumber);
    });
  });

  group('year', () {
    test('accepts a plausible model year', () {
      expect(Validators.year('2021'), isNull);
    });

    test('rejects years outside 1960..next year', () {
      expect(Validators.year('1959'), FieldError.invalidYear);
      expect(
        Validators.year('${DateTime.now().year + 2}'),
        FieldError.invalidYear,
      );
    });
  });

  group('plate', () {
    test('accepts Roman plates with spaces or dashes', () {
      expect(Validators.plate('BA 2 PA 1234'), isNull);
      expect(Validators.plate('ba-2-pa-1234'), isNull);
    });

    test('rejects free text and empty input', () {
      expect(Validators.plate('not a plate'), FieldError.invalidNumber);
      expect(Validators.plate(''), FieldError.required);
    });
  });

  test('requiredText and maxLength enforce bounds', () {
    expect(Validators.requiredText('Paint work'), isNull);
    expect(Validators.requiredText('', minLength: 3), FieldError.required);
    expect(Validators.requiredText('ab', minLength: 3), FieldError.tooShort);
    expect(Validators.maxLength('short', 10), isNull);
    expect(Validators.maxLength('x' * 11, 10), FieldError.tooLong);
  });
}
