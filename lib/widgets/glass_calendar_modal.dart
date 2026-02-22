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
    const highlightColor = Color(0xFFFF414D); // Vibrant Red from image

    return Center(
      child: Container(
        width: 380,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
              // Header matching image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      DateFormat('MMMM yyyy').format(_focusedDay),
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1E293B),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Color(0xFF64748B),
                          size: 28,
                        ),
                        onPressed: () => setState(() {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month - 1,
                          );
                        }),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF64748B),
                          size: 28,
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
              const SizedBox(height: 24),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                headerVisible: false,
                rowHeight: 52,
                daysOfWeekHeight: 40,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                enabledDayPredicate: (day) {
                  final normalizedDay = DateTime(day.year, day.month, day.day);
                  return entryDates.contains(normalizedDay) ||
                      isSameDay(day, DateTime.now());
                },
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.inter(
                    color: const Color(0xFF334155),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  weekendStyle: GoogleFonts.inter(
                    color: const Color(0xFF334155),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  weekendTextStyle: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  todayTextStyle: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                  ),
                  todayDecoration:
                      const BoxDecoration(), // Remove default today highlight
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: highlightColor,
                    shape: BoxShape.circle,
                  ),
                  outsideTextStyle: GoogleFonts.inter(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 16,
                  ),
                  disabledTextStyle: GoogleFonts.inter(
                    color: const Color(0xFFF1F5F9),
                    fontSize: 16,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final normalizedDay = DateTime(
                      date.year,
                      date.month,
                      date.day,
                    );
                    if (entryDates.contains(normalizedDay) &&
                        !isSameDay(_selectedDay, date)) {
                      return Positioned(
                        bottom: 8,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF94A3B8),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                    return null;
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
              if (entryDates.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "START JOURNALING TO SEE DATA",
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
