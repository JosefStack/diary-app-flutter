import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/entry_provider.dart';
import '../screens/day_entries_screen.dart';

class GlassCalendarModal extends StatefulWidget {
  const GlassCalendarModal({super.key});

  @override
  State<GlassCalendarModal> createState() => _GlassCalendarModalState();
}

class _GlassCalendarModalState extends State<GlassCalendarModal> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final entryProvider = context.watch<EntryProvider>();
    final entryDates = entryProvider.entryDates;
    const highlightColor = Color(0xFFFF4D4D); // Vibrant Red from image

    return Center(
      child: Container(
        width: 380,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pixel-perfect Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      DateFormat('MMMM yyyy').format(_focusedDay),
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1E293B),
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Color(0xFF1E293B),
                          size: 24,
                        ),
                        onPressed: () => setState(() {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month - 1,
                          );
                        }),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF1E293B),
                          size: 24,
                        ),
                        onPressed: () => setState(() {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month + 1,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerVisible: false,
                rowHeight: 56,
                daysOfWeekHeight: 48,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  weekendStyle: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(),
                  selectedDecoration: BoxDecoration(
                    color: highlightColor,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final normalizedDay = DateTime(
                      day.year,
                      day.month,
                      day.day,
                    );
                    final hasEntry = entryDates.contains(normalizedDay);
                    return _buildDayCell(day, hasEntry, false);
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    return _buildDayCell(day, false, true);
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: highlightColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  final normalizedDay = DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day,
                  );
                  if (entryDates.contains(normalizedDay)) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DayEntriesScreen(date: selectedDay),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, bool hasEntry, bool isOutside) {
    return Center(
      child: Text(
        '${day.day}',
        style: GoogleFonts.inter(
          color: const Color(
            0xFF1E293B,
          ).withOpacity(isOutside ? 0.1 : (hasEntry ? 1.0 : 0.4)),
          fontWeight: hasEntry ? FontWeight.bold : FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
