/// Standard System Usability Scale scoring: odd items score (x − 1), even
/// items score (5 − x), the sum is multiplied by 2.5 to span 0–100.
double susScore(List<int> answers) {
  if (answers.length != 10) {
    throw ArgumentError.value(answers, 'answers', 'SUS needs 10 answers');
  }
  var total = 0;
  for (var index = 0; index < answers.length; index++) {
    final value = answers[index];
    if (value < 1 || value > 5) {
      throw ArgumentError.value(value, 'answers[$index]', 'Use a 1–5 rating');
    }
    total += index.isEven ? value - 1 : 5 - value;
  }
  return total * 2.5;
}

/// Grade band used only to label a score in the UI, never to rank vehicles.
String susBand(double score) {
  if (score >= 85) return 'Excellent';
  if (score >= 72) return 'Good';
  if (score >= 52) return 'OK';
  return 'Needs work';
}
