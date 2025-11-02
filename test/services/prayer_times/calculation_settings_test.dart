import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/services/prayer_times/models/models.dart';

void main() {
  group('CalculationMethod Tests', () {
    test('getById returns correct method', () {
      final method = CalculationMethod.getById(3);
      expect(method, isNotNull);
      expect(method!.name, contains('Muslim World League'));
    });

    test('getById returns null for invalid ID', () {
      final method = CalculationMethod.getById(999);
      expect(method, isNull);
    });

    test('defaultMethod is Muslim World League', () {
      expect(CalculationMethod.defaultMethod.id, 3);
      expect(CalculationMethod.defaultMethod.name,
          contains('Muslim World League'));
    });

    test('allMethods contains all calculation methods', () {
      expect(CalculationMethod.allMethods.length, greaterThan(10));

      // Check some known methods exist
      final hasISNA = CalculationMethod.allMethods.any((m) => m.id == 2);
      final hasMWL = CalculationMethod.allMethods.any((m) => m.id == 3);
      final hasMakkah = CalculationMethod.allMethods.any((m) => m.id == 4);

      expect(hasISNA, isTrue);
      expect(hasMWL, isTrue);
      expect(hasMakkah, isTrue);
    });
  });

  group('IslamicSchool Tests', () {
    test('fromApiValue returns correct school', () {
      expect(IslamicSchool.fromApiValue(0), IslamicSchool.standard);
      expect(IslamicSchool.fromApiValue(1), IslamicSchool.hanafi);
    });

    test('fromApiValue defaults to standard for invalid value', () {
      expect(IslamicSchool.fromApiValue(999), IslamicSchool.standard);
    });

    test('apiValue returns correct values', () {
      expect(IslamicSchool.standard.apiValue, 0);
      expect(IslamicSchool.hanafi.apiValue, 1);
    });

    test('displayName returns correct names', () {
      expect(IslamicSchool.standard.displayName, contains('Standard'));
      expect(IslamicSchool.hanafi.displayName, contains('Hanafi'));
    });
  });
}
