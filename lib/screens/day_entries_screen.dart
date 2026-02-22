import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/diary_entry.dart';
import '../providers/entry_provider.dart';
import 'entry_display_screen.dart';
import '../utils/transitions.dart';

class DayEntriesScreen extends StatelessWidget {
  final DateTime date;

  const DayEntriesScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          DateFormat('MMMM dd, yyyy').format(date),
          style: GoogleFonts.shadowsIntoLight(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<EntryProvider>(
        builder: (context, entryProvider, _) {
          final dayEntries = entryProvider.entries.where((entry) {
            final entryDate = DateTime(
              entry.createdAt.year,
              entry.createdAt.month,
              entry.createdAt.day,
            );
            return entryDate.isAtSameMomentAs(normalizedDate);
          }).toList();

          if (dayEntries.isEmpty) {
            return Center(
              child: Text(
                'No entries for this day.',
                style: GoogleFonts.indieFlower(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: dayEntries.length,
            itemBuilder: (context, index) {
              final entry = dayEntries[index];
              return _EntryListItem(entry: entry);
            },
          );
        },
      ),
    );
  }
}

class _EntryListItem extends StatelessWidget {
  final DiaryEntry entry;

  const _EntryListItem({required this.entry});

  @override
  Widget build(BuildContext context) {
    Offset? tapPosition;
    return GestureDetector(
      onTapDown: (details) => tapPosition = details.globalPosition,
      onTap: () {
        if (tapPosition != null) {
          Navigator.push(
            context,
            RippleRoute(
              page: EntryDisplayScreen(entry: entry),
              center: tapPosition!,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getMoodColor(entry.mood),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.title.isEmpty ? 'Untitled' : entry.title,
                    style: GoogleFonts.indieFlower(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(entry.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              entry.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.indieFlower(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Excited':
        return Colors.yellow[100]!;
      case 'Calm':
        return Colors.blue[100]!;
      case 'Peaceful':
        return Colors.green[100]!;
      case 'Sad':
        return Colors.blueGrey[100]!;
      default:
        return Colors.red[100]!;
    }
  }
}
