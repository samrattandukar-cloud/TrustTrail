import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../core/widgets/tt_text_field.dart';
import '../../data/models/sus_response.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/sus_csv.dart';
import '../../domain/sus_scoring.dart';
import '../auth/session.dart';

final feedbackListProvider = FutureProvider.autoDispose<List<SusResponse>>((
  ref,
) async {
  return ref.watch(feedbackRepositoryProvider).list();
});

class SusScreen extends ConsumerStatefulWidget {
  const SusScreen({super.key});

  @override
  ConsumerState<SusScreen> createState() => _SusScreenState();
}

class _SusScreenState extends ConsumerState<SusScreen> {
  final _participant = TextEditingController(text: 'P01');
  final _comment = TextEditingController();
  final _answers = List<int>.filled(10, 0);
  var _busy = false;
  double? _lastScore;

  @override
  void dispose() {
    _participant.dispose();
    _comment.dispose();
    super.dispose();
  }

  List<String> _statements(AppLocalizations l10n) => [
    l10n.sus1,
    l10n.sus2,
    l10n.sus3,
    l10n.sus4,
    l10n.sus5,
    l10n.sus6,
    l10n.sus7,
    l10n.sus8,
    l10n.sus9,
    l10n.sus10,
  ];

  double _score() => susScore(_answers);

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (_answers.any((value) => value == 0)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.requiredField)));
      return;
    }
    final session = ref.read(sessionProvider).value;
    setState(() => _busy = true);
    try {
      final score = _score();
      await ref
          .read(feedbackRepositoryProvider)
          .insert(
            SusResponse(
              id: const Uuid().v4(),
              participantCode: _participant.text.trim().isEmpty
                  ? 'anonymous'
                  : _participant.text.trim(),
              role: session?.role.name ?? 'owner',
              answers: List<int>.from(_answers),
              susScore: score,
              comment: _comment.text.trim().isEmpty
                  ? null
                  : _comment.text.trim(),
              createdAt: DateTime.now(),
            ),
          );
      ref.invalidate(feedbackListProvider);
      if (!mounted) return;
      setState(() => _lastScore = score);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.susThanks)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() async {
    final l10n = context.l10n;
    final responses = await ref.read(feedbackRepositoryProvider).list();
    if (responses.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.susResponses)));
      return;
    }
    final csvText = susCsv([
      for (final response in responses)
        SusCsvEntry(
          participantCode: response.participantCode,
          role: response.role,
          submittedAt: response.createdAt,
          score: response.susScore,
          answers: response.answers,
          comment: response.comment,
        ),
    ]);
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/trusttrail_sus_'
      '${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(csvText);
    await SharePlus.instance.share(
      ShareParams(
        text: l10n.susExportShare(responses.length),
        files: [XFile(file.path)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final statements = _statements(l10n);
    final feedback = ref.watch(feedbackListProvider).value ?? const [];
    final average = feedback.isEmpty
        ? null
        : feedback.map((item) => item.susScore).reduce((a, b) => a + b) /
              feedback.length;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            TtSpace.page,
            8,
            TtSpace.page,
            TtSpace.page,
          ),
          children: [
            TtAppHeader(title: l10n.susTitle, eyebrow: l10n.feedback),
            const SizedBox(height: 8),
            Text(
              l10n.susIntro,
              style: TtType.body(palette.textSecondary, size: 13),
            ),
            const SizedBox(height: TtSpace.x4),
            TtTextField(
              label: l10n.susParticipant,
              controller: _participant,
              hint: 'P01',
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: TtSpace.x4),
            for (var index = 0; index < statements.length; index++) ...[
              _StatementCard(
                number: index + 1,
                statement: statements[index],
                value: _answers[index],
                onChanged: (value) => setState(() => _answers[index] = value),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: TtSpace.x2),
            TtTextField(
              label: l10n.susComment,
              controller: _comment,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            if (_lastScore != null) ...[
              const SizedBox(height: TtSpace.x4),
              TtStatusBanner(
                message:
                    '${l10n.susScore}: '
                    '${_lastScore!.toStringAsFixed(1)} / 100 · ${l10n.susThanks}',
                tone: TtBannerTone.success,
                icon: Icons.insights_rounded,
              ),
            ],
            const SizedBox(height: TtSpace.x4),
            TtPrimaryButton(
              label: l10n.susSubmit,
              icon: Icons.send_rounded,
              loading: _busy,
              onPressed: _submit,
            ),
            const SizedBox(height: TtSpace.x4),
            TtCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.susResponses,
                    style: TtType.label(palette.textPrimary, size: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.responsesCount(feedback.length),
                          style: TtType.body(palette.textSecondary, size: 12.5),
                        ),
                      ),
                      if (average != null)
                        Text(
                          '${l10n.susAverage}: ${average.toStringAsFixed(1)}',
                          style: TtType.data(palette.primary, size: 15),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TtSecondaryButton(
                    label: l10n.susExport,
                    icon: Icons.ios_share_rounded,
                    onPressed: _export,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.susCsvNote,
                    style: TtType.caption(palette.textSecondary, size: 10.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TtSpace.x3),
            Text(
              l10n.susFormulaNote,
              textAlign: TextAlign.center,
              style: TtType.caption(palette.textSecondary, size: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatementCard extends StatelessWidget {
  const _StatementCard({
    required this.number,
    required this.statement,
    required this.value,
    required this.onChanged,
  });

  final int number;
  final String statement;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TtCard(
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. $statement',
            style: TtType.body(palette.textPrimary, size: 12.5, height: 1.4),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 1; i <= 5; i++) ...[
                Expanded(
                  child: InkWell(
                    onTap: () => onChanged(i),
                    borderRadius: BorderRadius.circular(9),
                    child: Container(
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: value == i
                            ? palette.primary
                            : palette.surfaceRaised,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: value == i ? palette.primary : palette.border,
                        ),
                      ),
                      child: Text(
                        '$i',
                        style: TtType.data(
                          value == i ? Colors.white : palette.textPrimary,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                if (i != 5) const SizedBox(width: 5),
              ],
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.susScaleLow,
                style: TtType.caption(palette.textSecondary, size: 9.5),
              ),
              Text(
                context.l10n.susScaleHigh,
                style: TtType.caption(palette.textSecondary, size: 9.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
