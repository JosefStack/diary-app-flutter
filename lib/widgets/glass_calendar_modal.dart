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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final entryProvider = context.watch<EntryProvider>();
    final entryDates = entryProvider.entryDates;
    // Using a reddish accent as requested
    const highlightColor = Color(0xFF4F70F0);

    return Center(
      child: Container(
        width: 350,
        height: 420, // Adjusted height for custom header
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Custom Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HeaderButton(
                    icon: Icons.chevron_left,
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          _focusedDay.month - 1,
                        );
                      });
                    },
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(_focusedDay),
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  _HeaderButton(
                    icon: Icons.chevron_right,
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          _focusedDay.month + 1,
                        );
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 8),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                availableGestures: AvailableGestures.all,
                headerVisible: false, // Using custom header
                sixWeekMonthsEnforced: false,
                rowHeight: 48,
                daysOfWeekHeight: 32,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                enabledDayPredicate: (day) {
                  final normalizedDay = DateTime(day.year, day.month, day.day);
                  return entryDates.contains(normalizedDay) &&
                      day.isBefore(DateTime.now().add(const Duration(days: 1)));
                },
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  weekendStyle: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  weekendTextStyle: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  outsideTextStyle: GoogleFonts.inter(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 14,
                  ),
                  disabledTextStyle: GoogleFonts.inter(
                    color: const Color(0xFFE2E8F0),
                    fontSize: 14,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  todayTextStyle: const TextStyle(
                    color: highlightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: highlightColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: highlightColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final normalizedDay = DateTime(
                      date.year,
                      date.month,
                      date.day,
                    );
                    if (entryDates.contains(normalizedDay)) {
                      return Positioned(
                        bottom: 4,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: highlightColor,
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

                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DayEntriesScreen(date: selectedDay),
                    ),
                  );
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
              ),
              if (entryDates.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "No entries found",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFFCBD5E1), size: 24),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }
}
