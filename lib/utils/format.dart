const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "2026-11-26 23:59:00" -> "Nov 26". Returns null for "N/A" or bad input.
String? formatShortDate(String raw) {
  if (raw.isEmpty || raw == 'N/A') return null;
  final date = DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  if (date == null) return null;
  return '${_months[date.month - 1]} ${date.day}';
}

/// 6830 -> "6.8K", 131450 -> "131K", 1200000 -> "1.2M".
String formatCompact(int n) {
  String trim(String s) => s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  if (n >= 1000000) return '${trim((n / 1000000).toStringAsFixed(1))}M';
  if (n >= 100000) return '${(n / 1000).round()}K';
  if (n >= 1000) return '${trim((n / 1000).toStringAsFixed(1))}K';
  return '$n';
}

/// 6830 -> "6,830".
String formatThousands(int n) {
  final s = n.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
    buffer.write(s[i]);
  }
  return buffer.toString();
}
