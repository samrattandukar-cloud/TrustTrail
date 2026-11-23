import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/core/l10n/app_localizations.dart';
import 'package:trusttrail/core/theme/app_theme.dart';
import 'package:trusttrail/core/widgets/tt_buttons.dart';
import 'package:trusttrail/core/widgets/tt_completeness_meter.dart';
import 'package:trusttrail/core/widgets/tt_pills.dart';

Widget _host(Widget child, {bool dark = false, Locale? locale}) {
  return MaterialApp(
    theme: dark ? AppTheme.dark() : AppTheme.light(),
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('completion meter renders filled state and caption', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const TtCompletenessMeter(filled: 7, total: 10)),
    );

    expect(find.text('7/10'), findsOneWidget);
    expect(find.textContaining('trust score'), findsOneWidget);
  });

  testWidgets('plate chip shows Roman and Devanagari registration', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const TtPlateChip(roman: 'BA 2 PA 1234', devanagari: 'बा २ प १२३४'),
      ),
    );

    expect(find.text('BA 2 PA 1234'), findsOneWidget);
    expect(find.text('बा २ प १२३४'), findsOneWidget);
  });

  testWidgets('primary button is visible in dark theme', (tester) async {
    await tester.pumpWidget(
      _host(
        TtPrimaryButton(label: 'Continue', onPressed: () {}, expand: false),
        dark: true,
      ),
    );

    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Nepali locale renders Devanagari meter copy', (tester) async {
    await tester.pumpWidget(
      _host(
        const TtCompletenessMeter(filled: 4, total: 10),
        locale: const Locale('ne'),
      ),
    );

    expect(find.text('4/10'), findsOneWidget);
    expect(find.textContaining('विश्वास स्कोर'), findsOneWidget);
    expect(find.textContaining('trust score'), findsNothing);
  });

  testWidgets('dark theme uses dark brightness', (tester) async {
    Brightness? captured;
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) {
            captured = Theme.of(context).brightness;
            return const SizedBox.shrink();
          },
        ),
        dark: true,
      ),
    );

    expect(captured, Brightness.dark);
  });
}
