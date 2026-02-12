import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/diary_entry.dart';

class EntryProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<DiaryEntry> _entries = [];
  bool _loading = false;

  List<DiaryEntry> get entries => _entries;
  bool get isLoading => _loading;

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
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(String title, String content, String mood) async {
    final userId = _supabase.auth.currentUser!.id;
    final entry = DiaryEntry(
      id: '',
      userId: userId,
      title: title,
      content: content,
      mood: mood,
      createdAt: DateTime.now(),
    );

    await _supabase.from('entries').insert(entry.toJson());
    await fetchEntries();
  }

  Future<void> updateEntry(String id, String title, String content, String mood) async {
    await _supabase.from('entries').update({
      'title': title,
      'content': content,
      'mood': mood,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
    await fetchEntries();
  }

  Future<void> deleteEntry(String id) async {
    await _supabase.from('entries').delete().eq('id', id);
    await fetchEntries();
  }
}
