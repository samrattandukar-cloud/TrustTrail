import 'dart:math';

/// Report token codec: `TT-XXXX-XXXX` with a Crockford-style check character.
///
/// Tokens stand in for a snapshot row, never for a registry lookup. Lookups are
/// resolved against the local database, so the code is an identifier — not a
/// security boundary.
abstract final class TokenCodec {
  static const alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  static final _shape = RegExp(r'^[A-Z0-9]{8}$');

  static String generate([Random? random]) {
    final rng = random ?? Random.secure();
    final body = List.generate(
      7,
      (_) => alphabet[rng.nextInt(alphabet.length)],
    ).join();
    return format(body + _checkChar(body));
  }

  static String format(String compact) {
    final body = compact.toUpperCase();
    return 'TT-${body.substring(0, 4)}-${body.substring(4)}';
  }

  static String uri(String token) => 'trusttrail://r/${compact(token)}';

  /// Accepts a bare code, `TT-…` code, or a `trusttrail://r/…` URI.
  static String compact(String input) {
    var value = input.trim().toUpperCase();
    final lastSlash = value.lastIndexOf('/');
    if (value.contains('://') && lastSlash != -1) {
      value = value.substring(lastSlash + 1);
    }
    value = value.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (value.startsWith('TT') && value.length > 2) {
      value = value.substring(2);
    }
    return value;
  }

  /// Returns the canonical `TT-XXXX-XXXX` form when the input has the right
  /// shape. Check characters are only enforced for generated tokens.
  static String? tryParse(String input) {
    final body = compact(input);
    if (!_shape.hasMatch(body)) return null;
    return format(body);
  }

  static bool isChecksumValid(String input) {
    final body = compact(input);
    if (!_shape.hasMatch(body)) return false;
    return _checkChar(body.substring(0, 7)) == body[7];
  }

  static String _checkChar(String body) {
    var sum = 0;
    for (var i = 0; i < body.length; i++) {
      sum += alphabet.indexOf(body[i]) * (i + 1);
    }
    return alphabet[sum % alphabet.length];
  }
}
