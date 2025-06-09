import 'dart:math';

import 'package:flutter/material.dart';
import 'package:impact/models/booking.dart';
import 'package:impact/models/user.dart';
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


  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadUserBookings(_focusedDay);
  }

  User placeholderUser = User(name: 'John', lastName: 'Doe', username: 'johndoe', email: 'johndoe@example.com', joinDate: DateTime.now(), isPremium: true);

  void _loadUserBookings(DateTime date) {
    setState(() {
      final random = Random();
      final int yearToUse = _selectedDay?.year ?? _focusedDay.year;
      final DateTime startDateCandidates = DateTime(yearToUse, 2, 20);
      final DateTime endDateCandidates = DateTime.now();

      final DateTime startDate = startDateCandidates.isAfter(endDateCandidates) ? endDateCandidates : startDateCandidates;
      final DateTime endDate = endDateCandidates;
      
      if (startDate.isAfter(endDate)) {
        _userBookings = [];
        _bookingDates = [];
        return;
      }

      final differenceInDays = endDate.difference(startDate).inDays;
      
      if (differenceInDays < 0) {
          _userBookings = [];
          _bookingDates = [];
          return;
      }

      List<Booking> newBookings = [];
      List<DateTime> newBookingDates = [];

      for (int i = 0; i < 30; i++) {
        final randomDays = differenceInDays == 0 ? 0 : random.nextInt(differenceInDays + 1);
        final baseDate = startDate.add(Duration(days: randomDays));
        
        // Generar startTime y endTime aleatorios para la reserva
        final hour = random.nextInt(24);
        final minute = random.nextInt(60);
        final startTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
        final endTime = startTime.add(Duration(hours: random.nextInt(2) + 1)); // Duración entre 1 y 2 horas

        final booking = Booking(
          startTime: startTime,
          endTime: endTime,
          user: placeholderUser, // Usar el usuario placeholder
        );
        newBookings.add(booking);
        newBookingDates.add(DateTime.utc(startTime.year, startTime.month, startTime.day));
      }
      _userBookings = newBookings;
      // Filtrar para mantener solo las fechas únicas para los marcadores del calendario
      _bookingDates = newBookingDates.toSet().toList(); 
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _bookingDates.where((bookingDate) => isSameDay(bookingDate, normalizedDay)).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _loadUserBookings(selectedDay);
    }
  }

  void _createNewBooking() {
    // TODO: Navigate to a new screen or show a dialog to create a booking
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Crear nueva reserva presionado')),
    );
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

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
          Expanded(
            child: _userBookings.isEmpty
                ? const Center(child: Text('No hay reservas para este día.'))
                : ListView.builder(
                    itemCount: _userBookings.length,
                    itemBuilder: (context, index) {
                      final booking = _userBookings[index]; // Obtener el objeto Booking
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        color: theme.colorScheme.secondary,
                        child: ListTile(
                          // Mostrar información del Booking
                          title: Text(
                              'Reserva para ${booking.user.name} - ${booking.startTime.hour}:${booking.startTime.minute.toString().padLeft(2, '0')}',
                          ),
                          subtitle: Text(
                              'Fecha: ${booking.startTime.day}/${booking.startTime.month}/${booking.startTime.year}\nFin: ${booking.endTime.hour}:${booking.endTime.minute.toString().padLeft(2, '0')}'
                          ),
                          textColor: theme.colorScheme.onSecondary, // Ajustado para mejor contraste
                          // TODO: Add more booking details or actions
                        ),
                      );
                    },
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