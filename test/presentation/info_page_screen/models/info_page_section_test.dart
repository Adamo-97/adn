import 'package:flutter_test/flutter_test.dart';
import 'package:adam_s_application/presentation/info_page_screen/models/info_page_section.dart';

/// Unit tests for InfoPageSection model
/// Tests JSON parsing, copyWith, and Equatable implementation
void main() {
  group('InfoPageSection Model Tests', () {
    group('fromJson - Boundary Value Analysis', () {
      test('parses section_title type correctly', () {
        final json = {
          'type': 'section_title',
          'text': 'Test Section Title',
        };

        final section = InfoPageSection.fromJson(json);

        expect(section.type, SectionType.sectionTitle);
        expect(section.text, 'Test Section Title');
        expect(section.illustration, null);
        expect(section.items, null);
      });

      test('parses paragraph type with illustration', () {
        final json = {
          'type': 'paragraph',
          'text': 'Test paragraph content',
          'illustration': 'assets/images/info_pages/test.svg',
        };

        final section = InfoPageSection.fromJson(json);

        expect(section.type, SectionType.paragraph);
        expect(section.text, 'Test paragraph content');
        expect(section.illustration, 'assets/images/info_pages/test.svg');
        expect(section.items, null);
      });

      test('parses list type with items', () {
        final json = {
          'type': 'list',
          'items': ['Item 1', 'Item 2', 'Item 3'],
        };

        final section = InfoPageSection.fromJson(json);

        expect(section.type, SectionType.list);
        expect(section.items, ['Item 1', 'Item 2', 'Item 3']);
        expect(section.text, null);
        expect(section.illustration, null);
      });

      test('throws ArgumentError for unknown type', () {
        final json = {
          'type': 'invalid_type',
          'text': 'Test',
        };

        expect(
          () => InfoPageSection.fromJson(json),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('handles empty list', () {
        final json = {
          'type': 'list',
          'items': <String>[],
        };

        final section = InfoPageSection.fromJson(json);

        expect(section.type, SectionType.list);
        expect(section.items, isEmpty);
      });

      test('handles very long text (boundary)', () {
        final longText = 'A' * 10000; // 10,000 characters
        final json = {
          'type': 'paragraph',
          'text': longText,
        };

        final section = InfoPageSection.fromJson(json);

        expect(section.type, SectionType.paragraph);
        expect(section.text, longText);
        expect(section.text?.length, 10000);
      });
    });

    group('toJson - State Transition', () {
      test('converts section_title to JSON', () {
        final section = InfoPageSection(
          type: SectionType.sectionTitle,
          text: 'Test Title',
        );

        final json = section.toJson();

        expect(json['type'], 'section_title');
        expect(json['text'], 'Test Title');
        expect(json.containsKey('illustration'), false);
        expect(json.containsKey('items'), false);
      });

      test('converts paragraph with illustration to JSON', () {
        final section = InfoPageSection(
          type: SectionType.paragraph,
          text: 'Test paragraph',
          illustration: 'test.svg',
        );

        final json = section.toJson();

        expect(json['type'], 'paragraph');
        expect(json['text'], 'Test paragraph');
        expect(json['illustration'], 'test.svg');
      });

      test('converts list to JSON', () {
        final section = InfoPageSection(
          type: SectionType.list,
          items: ['One', 'Two', 'Three'],
        );

        final json = section.toJson();

        expect(json['type'], 'list');
        expect(json['items'], ['One', 'Two', 'Three']);
      });
    });

    group('copyWith - Immutability Testing', () {
      test('creates new instance with updated text', () {
        final original = InfoPageSection(
          type: SectionType.paragraph,
          text: 'Original text',
        );

        final updated = original.copyWith(text: 'Updated text');

        expect(updated.text, 'Updated text');
        expect(original.text, 'Original text'); // Original unchanged
        expect(identical(original, updated), false);
      });

      test('creates new instance with updated type', () {
        final original = InfoPageSection(
          type: SectionType.paragraph,
          text: 'Test',
        );

        final updated = original.copyWith(type: SectionType.sectionTitle);

        expect(updated.type, SectionType.sectionTitle);
        expect(original.type, SectionType.paragraph);
      });

      test('maintains unchanged fields', () {
        final original = InfoPageSection(
          type: SectionType.paragraph,
          text: 'Test',
          illustration: 'test.svg',
        );

        final updated = original.copyWith(text: 'New text');

        expect(updated.text, 'New text');
        expect(updated.illustration, 'test.svg'); // Maintained
        expect(updated.type, SectionType.paragraph); // Maintained
      });
    });

    group('Equatable - Equivalence Partitioning', () {
      test('sections with same values are equal', () {
        final section1 = InfoPageSection(
          type: SectionType.paragraph,
          text: 'Test',
        );

        final section2 = InfoPageSection(
          type: SectionType.paragraph,
          text: 'Test',
        );

        expect(section1, equals(section2));
      });

      test('sections with different text are not equal', () {
        final section1 = InfoPageSection(
          type: SectionType.paragraph,
          text: 'Test 1',
        );

        final section2 = InfoPageSection(
          type: SectionType.paragraph,
          text: 'Test 2',
        );

        expect(section1, isNot(equals(section2)));
      });

      test('sections with different types are not equal', () {
        final section1 = InfoPageSection(
          type: SectionType.paragraph,
          text: 'Test',
        );

        final section2 = InfoPageSection(
          type: SectionType.sectionTitle,
          text: 'Test',
        );

        expect(section1, isNot(equals(section2)));
      });

      test('sections with different items are not equal', () {
        final section1 = InfoPageSection(
          type: SectionType.list,
          items: ['A', 'B'],
        );

        final section2 = InfoPageSection(
          type: SectionType.list,
          items: ['A', 'C'],
        );

        expect(section1, isNot(equals(section2)));
      });
    });

    group('SectionTypeExtension Tests', () {
      test('fromString converts all valid types', () {
        expect(
          SectionTypeExtension.fromString('section_title'),
          SectionType.sectionTitle,
        );
        expect(
          SectionTypeExtension.fromString('paragraph'),
          SectionType.paragraph,
        );
        expect(
          SectionTypeExtension.fromString('list'),
          SectionType.list,
        );
      });

      test('toJsonString converts all enum values', () {
        expect(SectionType.sectionTitle.toJsonString(), 'section_title');
        expect(SectionType.paragraph.toJsonString(), 'paragraph');
        expect(SectionType.list.toJsonString(), 'list');
      });

      test('round-trip conversion maintains type', () {
        for (final type in SectionType.values) {
          final jsonString = type.toJsonString();
          final converted = SectionTypeExtension.fromString(jsonString);
          expect(converted, type);
        }
      });
    });
  });
}
