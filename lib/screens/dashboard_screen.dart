import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/entry_provider.dart';
import '../models/diary_entry.dart';
import 'entry_editor_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<EntryProvider>().fetchEntries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('Memoir', style: GoogleFonts.shadowsIntoLight(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 40 )),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.black,),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: Consumer<EntryProvider>(
        builder: (context, entryProvider, _) {
          if (entryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (entryProvider.entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_note, size: 64, color: Colors.grey[500]),
                  const SizedBox(height: 16),
                  Text('Your safe space is empty.', style: GoogleFonts.indieFlower(color: Colors.grey[900])),
                  const SizedBox(height: 8),
                   Text('Tap + to start journaling.', style: GoogleFonts.indieFlower(color: Colors.grey[900])),
                ],
              ),
            );
          }

          // Group by month
          final grouped = <String, List<DiaryEntry>>{};
          for (var entry in entryProvider.entries) {
            final month = DateFormat('MMMM yyyy').format(entry.createdAt);
            grouped.putIfAbsent(month, () => []).add(entry);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 24),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final month = grouped.keys.elementAt(index);
              final entries = grouped[month]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...entries.map((entry) => _EntryCard(entry: entry)),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EntryEditorScreen()),
        ),
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final DiaryEntry entry;
  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EntryEditorScreen(entry: entry)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:Colors.grey[100],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      DateFormat('dd').format(entry.createdAt),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      DateFormat('MMM').format(entry.createdAt).toUpperCase(),
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 15,),
          SizedBox(
            width: 300,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: entry.mood=='Excited' ? Colors.yellow[100] 
                : entry.mood=='Calm' ? Colors.blue[100] 
                : entry.mood=='Peaceful' ? Colors.green[100] 
                : entry.mood=='Sad' ? Colors.blueGrey[100] 
                : Colors.red[100],

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                
                  const SizedBox(width:30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title.isEmpty ? 'Untitled' : entry.title,
                          style: GoogleFonts.indieFlower(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(color: Colors.grey[500], fontSize: 13,fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(DateFormat('hh:mm a').format(entry.createdAt),
                                style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(width: 12),
                            const Icon(Icons.mood, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(entry.mood, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
