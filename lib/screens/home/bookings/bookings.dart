import 'dart:math';

import 'package:flutter/material.dart';
import 'package:impact/models/booking.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/home/bookings/new_booking_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Booking> _userBookings = [];
  List<DateTime> _bookingDates = [];
  bool _isTouched = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadUserBookings(_focusedDay);
  }

  User placeholderUser = User(
    name: 'John',
    lastName: 'Doe',
    username: 'johndoe',
    email: 'johndoe@example.com',
    joinDate: DateTime.now(),
    isPremium: true,
  );

  void _loadUserBookings(DateTime date) {
    setState(() {
      List<Booking> newBookings = [];
      List<DateTime> newBookingDates = [];

      // define the start and end dates for the fixed events
      final DateTime startDate = DateTime(2025, 6, 1);
      final DateTime endDate = DateTime(2025, 12, 31);

      DateTime currentDate = startDate;

      while (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        // check if the current day is Monday, Wednesday, or Friday
        if (currentDate.weekday == DateTime.monday ||
            currentDate.weekday == DateTime.wednesday ||
            currentDate.weekday == DateTime.friday) {
          // create a placeholder start and end time for the booking
          final startTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            9,
            0,
          ); // 9:00 AM
          final endTime = startTime.add(
            const Duration(hours: 1),
          ); // 1 hour duration

          final booking = Booking(
            startTime: startTime,
            endTime: endTime,
            user: placeholderUser,
          );
          newBookings.add(booking);
          newBookingDates.add(
            DateTime.utc(startTime.year, startTime.month, startTime.day),
          );
        }
        // move to the next day
        currentDate = currentDate.add(const Duration(days: 1));
      }

      _userBookings = newBookings;
      _bookingDates = newBookingDates
          .toSet()
          .toList(); // ensure unique dates for calendar markers
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _bookingDates
        .where((bookingDate) => isSameDay(bookingDate, normalizedDay))
        .toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _isTouched = true;
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _loadUserBookings(selectedDay);
    }
  }

  void _createNewBooking() {
    // show the NewBookingDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const NewBookingDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    List<Booking> bookingsForSelectedDay = [];
    // filter bookings for the selected day
    if (_selectedDay != null) {
      bookingsForSelectedDay = _userBookings.where((booking) {
        final bookingDate = DateTime.utc(
          booking.startTime.year,
          booking.startTime.month,
          booking.startTime.day,
        );
        final selectedDate = DateTime.utc(
          _selectedDay!.year,
          _selectedDay!.month,
          _selectedDay!.day,
        );
        return isSameDay(bookingDate, selectedDate);
      }).toList();
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
            ),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              !_isTouched
                  ? 'Todas las reservas programadas'
                  : (_selectedDay != null
                        ? 'Reservas para ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}'
                        : 'Selecciona un día'),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
          Expanded(
            child: _selectedDay == null
                ? const Center(
                    child: Text(
                      'Por favor, selecciona un día para ver las reservas.',
                    ),
                  )
                : bookingsForSelectedDay.isEmpty
                ? const Center(
                    child: Text('Aún no hay reservas para este día.'),
                  )
                : SingleChildScrollView(
                    // allows scrolling if there are many cards for a single day
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: bookingsForSelectedDay.map((booking) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          color: theme.colorScheme.secondary,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reserva - Usuario: ${booking.user.name}',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Hora de inicio: ${booking.startTime}',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSecondary,
                                  ),
                                ),
                                Text(
                                  'Hora de fin: ${booking.endTime}',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSecondary,
                                  ),
                                ),
                                // you can add more details from the booking object here
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewBooking,
        tooltip: 'Crear Reserva',
        child: const Icon(Icons.add),
      ),
    );
  }
}
