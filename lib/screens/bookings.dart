import 'package:flutter/material.dart';
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
  List<String> _userBookings = []; // Placeholder for user bookings

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadUserBookings(_focusedDay);
  }

  void _loadUserBookings(DateTime date) {
    setState(() {
      _userBookings = List.generate(
        5, // Simulate 5 bookings for the selected day
        (index) => 'Reserva ${index + 1} para ${date.day}/${date.month}/${date.year}',
      ).take(30).toList(); // Max 30 bookings
    });
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
    return Scaffold(
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
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          title: Text(_userBookings[index]),
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