import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
      backgroundColor:widget.entry?.mood=='Excited' ? Colors.yellow[100] 
                : widget.entry?.mood=='Calm' ? Colors.blue[100] 
                :widget.entry?.mood=='Peaceful' ? Colors.green[100] 
                : widget.entry?.mood=='Sad' ? Colors.blueGrey[100] 
                :widget.entry?.mood=='frustrated' ? Colors.red[100]
                : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: widget.entry?.mood=='Excited' ? Colors.yellow[100] 
                : widget.entry?.mood=='Calm' ? Colors.blue[100] 
                :widget.entry?.mood=='Peaceful' ? Colors.green[100] 
                : widget.entry?.mood=='Sad' ? Colors.blueGrey[100] 
                :widget.entry?.mood=='frustrated' ? Colors.red[100]
                : Colors.white,
        title: Text(
          widget.entry == null ? 'New Entry' : 'Edit Entry',
          style: GoogleFonts.indieFlower(color: Colors.black,fontWeight: FontWeight.bold),
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
                    style: GoogleFonts.indieFlower(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.black),
                    decoration:  InputDecoration(
                      hintText: 'Title',
                      hintStyle: GoogleFonts.indieFlower(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.mood, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        
                        iconEnabledColor: Colors.black,
                        value: _mood,
                        dropdownColor: Colors.grey[200],
                        underline: Container(),
                        items: ['Calm', 'Excited', 'Peaceful', 'Sad', 'Frustrated']
                            .map((m) => DropdownMenuItem(value: m, child: Text(m,style: GoogleFonts.indieFlower(color: Colors.black,fontSize: 20),)))
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
                    decoration:  InputDecoration(
                      hintText: 'Start writing...',
                      hintStyle: GoogleFonts.indieFlower(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24,left: 24,bottom: 40),
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
                  backgroundColor: Colors.teal[200],
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
