import 'package:flutter_test/flutter_test.dart';
import 'package:gamerpower_giveaways/models/giveaway.dart';
import 'package:gamerpower_giveaways/utils/format.dart';

void main() {
  group('Giveaway.fromJson', () {
    final json = {
      'id': 3853,
      'title': 'Mark of the Deep (Epic Games) Giveaway',
      'worth': r'$19.99',
      'thumbnail': 'https://www.gamerpower.com/offers/1/6aff1d0e4942d.jpg',
      'image': 'https://www.gamerpower.com/offers/1b/6aff1d0e4942d.jpg',
      'description': 'Score Mark of the Deep for free on Epic Games Store!',
      'instructions': '1. Click the button to visit the giveaway page.\r\n'
          '2. Login into your Epic Games Store account.\r\n'
          '3. Click the button to add the game to your library',
      'open_giveaway_url':
          'https://www.gamerpower.com/open/mark-of-the-deep-epic-games-giveaway',
      'published_date': '2026-11-19 11:00:14',
      'type': 'Game',
      'platforms': 'PC, Epic Games Store',
      'end_date': '2026-11-26 23:59:00',
      'users': 6830,
      'status': 'Active',
    };

    test('parses fields', () {
      final g = Giveaway.fromJson(json);
      expect(g.id, 3853);
      expect(g.hasWorth, isTrue);
      expect(g.platformList, ['PC', 'Epic Games Store']);
      expect(g.steps.length, 3);
      expect(g.steps.first, 'Click the button to visit the giveaway page.');
      expect(g.isActive, isTrue);
    });

    test('treats N/A worth as free', () {
      final g = Giveaway.fromJson({...json, 'worth': 'N/A'});
      expect(g.hasWorth, isFalse);
    });
  });

  group('format helpers', () {
    test('short date', () {
      expect(formatShortDate('2026-11-26 23:59:00'), 'Nov 26');
      expect(formatShortDate('N/A'), isNull);
    });

    test('compact numbers', () {
      expect(formatCompact(950), '950');
      expect(formatCompact(6830), '6.8K');
      expect(formatCompact(131450), '131K');
      expect(formatCompact(1000), '1K');
    });

    test('thousands separator', () {
      expect(formatThousands(6830), '6,830');
      expect(formatThousands(1234567), '1,234,567');
    });
  });
}
