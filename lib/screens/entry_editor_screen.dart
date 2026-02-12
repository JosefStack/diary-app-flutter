import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/entry_provider.dart';
import '../models/diary_entry.dart';

class EntryEditorScreen extends StatefulWidget {
  final DiaryEntry? entry;
  const EntryEditorScreen({super.key, this.entry});

  @override
  State<EntryEditorScreen> createState() => _EntryEditorScreenState();
}

class _EntryEditorScreenState extends State<EntryEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _mood;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
    _mood = widget.entry?.mood ?? 'Calm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entry == null ? 'New Entry' : 'Edit Entry',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () async {
                await context.read<EntryProvider>().deleteEntry(widget.entry!.id);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.mood, size: 16, color: Color(0xFF10B981)),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _mood,
                        dropdownColor: const Color(0xFF1F2937),
                        underline: Container(),
                        items: ['Calm', 'Excited', 'Peaceful', 'Sad', 'Frustrated']
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (val) => setState(() => _mood = val!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    style: const TextStyle(fontSize: 18, height: 1.6, color: Color(0xFFCBD5E1)),
                    decoration: const InputDecoration(
                      hintText: 'Start writing...',
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.entry == null) {
                    await context.read<EntryProvider>().addEntry(
                      _titleController.text,
                      _contentController.text,
                      _mood,
                    );
                  } else {
                    await context.read<EntryProvider>().updateEntry(
                      widget.entry!.id,
                      _titleController.text,
                      _contentController.text,
                      _mood,
                    );
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save Entry', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
