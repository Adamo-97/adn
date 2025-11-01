import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/app_export.dart';
import '../../salah_guide_screen/models/salah_guide_card_model.dart';
import '../models/info_page_content.dart';

part 'info_page_state.dart';

/// Provider for InfoPage notifier
/// Manages info page content loading, card-to-JSON mapping, and category colors
final infoPageNotifierProvider =
    NotifierProvider.autoDispose<InfoPageNotifier, InfoPageState>(
  () => InfoPageNotifier(),
);

class InfoPageNotifier extends Notifier<InfoPageState> {
  @override
  InfoPageState build() {
    // Initial state with defaults - will be initialized by screen
    return InfoPageState(
      cardTitle: '',
      category: SalahCategory.essentials,
      accentColor: appColors.salahEssentials, // Teal default
    );
  }

  /// Initialize the notifier with card title and category
  /// Must be called before loading content
  void initialize(String cardTitle, SalahCategory category) {
    state = InfoPageState(
      cardTitle: cardTitle,
      category: category,
      accentColor: category.accentColor,
      isLoading: true,
    );
    Future.microtask(() => loadInfoPageContent());
  }

  /// Maps card titles to JSON filenames
  /// Returns the JSON filename for the given card title
  String _getJsonFilenameForCard(String cardTitle) {
    final mapping = {
      'Importance of Prayer': 'prayer_introduction',
      'How To Pray': 'how_to_pray',
      'Prayer Times': 'prayer_times',
      'Conditions of Prayer': 'conditions_of_prayer',
      'Rawatib Prayers': 'rawatib_prayers',
      'Witr Prayer': 'witr_prayer',
      'Tahajjud Prayer': 'tahajjud_prayer',
      'Istikharah Prayer': 'istikharah_prayer',
      'Traveling Prayer': 'prayer_while_traveling',
      'Prayer of the Ill': 'prayer_of_the_ill',
      'Janazah Prayer': 'janazah_prayer',
      'Kusuf Prayer': 'kusuf_prayer',
      'Congregational Prayer': 'congregational_prayer',
      'Forgetfulness Prostration': 'forgetfulness_prostration',
      'Eid Prayer': 'eid_prayer',
      'Jumu\'ah Prayer': 'jumuah_prayer',
      'Wudu (Ablution)': 'wudu_guide',
      'Ghusl (Full Bath)': 'ghusl_guide',
      'Tayammum': 'substitute_ablution',
      'Historical Overview': 'historical_overview',
      'Hajj Guide': 'hajj_guide',
      'Umrah Guide': 'umrah_guide',
    };

    return mapping[cardTitle] ?? '';
  }

  /// Loads info page content from JSON file
  /// Handles parsing and error states
  Future<void> loadInfoPageContent() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final jsonFilename = _getJsonFilenameForCard(state.cardTitle);
      
      if (jsonFilename.isEmpty) {
        throw Exception('No JSON file mapped for card: ${state.cardTitle}');
      }

      // Load JSON file from assets (correct path)
      final jsonString = await rootBundle
          .loadString('assets/data/info_pages/en/$jsonFilename.json');
      
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final content = InfoPageContent.fromJson(jsonData);

      state = state.copyWith(
        content: content,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load content: $e',
      );
    }
  }
}
