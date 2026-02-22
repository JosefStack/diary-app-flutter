import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/diary_entry.dart';

class EntryProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<DiaryEntry> _entries = [];
  bool _loading = false;

  List<DiaryEntry> get entries => _entries;
  bool get isLoading => _loading;

  // Memoized entry dates for calendar performance
  Set<DateTime> get entryDates => _entries
      .map(
        (e) => DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day),
      )
      .toSet();

  Future<void> fetchEntries() async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _supabase
          .from('entries')
          .select()
          .order('created_at', ascending: false);

      _entries = (response as List)
          .map((json) => DiaryEntry.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("Error fetching entries: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(String title, String content, String mood) async {
    final userId = _supabase.auth.currentUser!.id;
    final now = DateTime.now();

    final newEntry = DiaryEntry(
      id: 'temp_${now.millisecondsSinceEpoch}',
      userId: userId,
      title: title,
      content: content,
      mood: mood,
      createdAt: now,
    );

    // Optimistic Update
    _entries.insert(0, newEntry);
    notifyListeners();

    try {
      final json = newEntry.toJson();
      json.remove('id'); // Let DB generate ID
      await _supabase.from('entries').insert(json);
      await fetchEntries(); // Sync with DB
    } catch (e) {
      _entries.remove(newEntry);
      notifyListeners();
      debugPrint("Error adding entry: $e");
    }
  }

  Future<void> updateEntry(
    String id,
    String title,
    String content,
    String mood,
  ) async {
    final oldEntryIndex = _entries.indexWhere((e) => e.id == id);
    if (oldEntryIndex == -1) return;

    final oldEntry = _entries[oldEntryIndex];
    final updatedEntry = DiaryEntry(
      id: id,
      userId: oldEntry.userId,
      title: title,
      content: content,
      mood: mood,
      createdAt: oldEntry.createdAt,
    );

    // Optimistic Update
    _entries[oldEntryIndex] = updatedEntry;
    notifyListeners();

    try {
      await _supabase
          .from('entries')
          .update({
            'title': title,
            'content': content,
            'mood': mood,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      _entries[oldEntryIndex] = oldEntry;
      notifyListeners();
      debugPrint("Error updating entry: $e");
    }
  }

  Future<void> deleteEntry(String id) async {
    final entryIndex = _entries.indexWhere((e) => e.id == id);
    if (entryIndex == -1) return;

    final deletedEntry = _entries[entryIndex];

    // Optimistic Update
    _entries.removeAt(entryIndex);
    notifyListeners();

    try {
      await _supabase.from('entries').delete().eq('id', id);
    } catch (e) {
      _entries.insert(entryIndex, deletedEntry);
      notifyListeners();
      debugPrint("Error deleting entry: $e");
    }
  }
}
