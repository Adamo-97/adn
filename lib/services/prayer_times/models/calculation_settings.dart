import 'package:equatable/equatable.dart';

/// Represents the calculation method used for prayer time calculations
///
/// Each method represents a different Islamic organization's calculation standards
/// for determining prayer times, particularly Fajr and Isha angles.
class CalculationMethod extends Equatable {
  /// Unique identifier for the calculation method (used in API calls)
  final int id;

  /// Display name for the calculation method
  final String name;

  /// Optional description providing details about the method
  final String? description;

  const CalculationMethod({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];

  /// All available calculation methods supported by Aladhan API
  static const List<CalculationMethod> allMethods = [
    CalculationMethod(
      id: 0,
      name: 'Shia Ithna-Ansari',
      description: 'Shia Ithna Ashari, Leva Research Institute, Qum',
    ),
    CalculationMethod(
      id: 1,
      name: 'University of Islamic Sciences, Karachi',
      description: 'Fajr: 18°, Isha: 18°',
    ),
    CalculationMethod(
      id: 2,
      name: 'Islamic Society of North America (ISNA)',
      description: 'Fajr: 15°, Isha: 15°',
    ),
    CalculationMethod(
      id: 3,
      name: 'Muslim World League (MWL)',
      description: 'Fajr: 18°, Isha: 17°',
    ),
    CalculationMethod(
      id: 4,
      name: 'Umm Al-Qura University, Makkah',
      description: 'Fajr: 18.5°, Isha: 90 min after Maghrib',
    ),
    CalculationMethod(
      id: 5,
      name: 'Egyptian General Authority of Survey',
      description: 'Fajr: 19.5°, Isha: 17.5°',
    ),
    CalculationMethod(
      id: 7,
      name: 'Institute of Geophysics, University of Tehran',
      description: 'Fajr: 17.7°, Isha: 14°',
    ),
    CalculationMethod(
      id: 8,
      name: 'Gulf Region',
      description: 'Used in Gulf countries',
    ),
    CalculationMethod(
      id: 9,
      name: 'Kuwait',
      description: 'Fajr: 18°, Isha: 17.5°',
    ),
    CalculationMethod(
      id: 10,
      name: 'Qatar',
      description: 'Modified version of Umm al-Qura',
    ),
    CalculationMethod(
      id: 11,
      name: 'Majlis Ugama Islam Singapura, Singapore',
      description: 'Fajr: 20°, Isha: 18°',
    ),
    CalculationMethod(
      id: 12,
      name: 'Union Organization Islamic de France',
      description: 'Fajr: 12°, Isha: 12°',
    ),
    CalculationMethod(
      id: 13,
      name: 'Diyanet İşleri Başkanlığı, Turkey',
      description: 'Fajr: 18°, Isha: 17°',
    ),
    CalculationMethod(
      id: 14,
      name: 'Spiritual Administration of Muslims of Russia',
      description: 'Used in Russia',
    ),
    CalculationMethod(
      id: 15,
      name: 'Moonsighting Committee Worldwide',
      description: 'Fajr: 18°, Isha: Seasonal',
    ),
    CalculationMethod(
      id: 16,
      name: 'Dubai (unofficial)',
      description: 'Fajr: 18.2°, Isha: 18.2°',
    ),
  ];

  /// Get calculation method by ID
  static CalculationMethod? getById(int id) {
    try {
      return allMethods.firstWhere((method) => method.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get default calculation method (Muslim World League)
  static const CalculationMethod defaultMethod = CalculationMethod(
    id: 3,
    name: 'Muslim World League (MWL)',
    description: 'Fajr: 18°, Isha: 17°',
  );
}

/// Represents the Islamic school/madhab for Asr calculation
///
/// Different schools calculate Asr time differently based on shadow length
enum IslamicSchool {
  /// Standard (Shafi'i, Maliki, Hanbali): Asr when shadow = object length + shadow at noon
  standard(0, 'Standard (Shafi\'i, Maliki, Hanbali)'),

  /// Hanafi: Asr when shadow = 2 × object length + shadow at noon
  hanafi(1, 'Hanafi');

  /// API value used in Aladhan API calls
  final int apiValue;

  /// Display name for the school
  final String displayName;

  const IslamicSchool(this.apiValue, this.displayName);

  /// Get school by API value
  static IslamicSchool fromApiValue(int value) {
    return IslamicSchool.values.firstWhere(
      (school) => school.apiValue == value,
      orElse: () => IslamicSchool.standard,
    );
  }
}
