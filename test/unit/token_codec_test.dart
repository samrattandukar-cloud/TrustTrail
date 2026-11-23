import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/core/utils/token_codec.dart';

void main() {
  group('TokenCodec', () {
    test('generates valid, formatted and checksummed tokens', () {
      for (var i = 0; i < 50; i++) {
        final token = TokenCodec.generate();
        expect(RegExp(r'^TT-[0-9A-Z]{4}-[0-9A-Z]{4}$').hasMatch(token), isTrue);
        expect(TokenCodec.isChecksumValid(token), isTrue);
        expect(TokenCodec.tryParse(token), token);
      }
    });

    test('accepts bare codes, formatted codes and QR URIs', () {
      expect(TokenCodec.tryParse('TT-SHIN-2026'), 'TT-SHIN-2026');
      expect(TokenCodec.tryParse('tt shin 2026'), 'TT-SHIN-2026');
      expect(
        TokenCodec.tryParse('trusttrail://r/TT-SHIN-2026'),
        'TT-SHIN-2026',
      );
      expect(TokenCodec.uri('TT-SHIN-2026'), 'trusttrail://r/SHIN2026');
    });

    test('rejects malformed tokens', () {
      expect(TokenCodec.tryParse('TT-123'), isNull);
      expect(TokenCodec.tryParse(''), isNull);
      expect(TokenCodec.isChecksumValid('TT-AAAA-AAAA'), isFalse);
    });
  });
}
