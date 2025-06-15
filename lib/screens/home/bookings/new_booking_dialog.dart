import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date and time formatting

class NewBookingDialog extends StatefulWidget {
  const NewBookingDialog({super.key});

  @override
  State<NewBookingDialog> createState() => _NewBookingDialogState();
}

class _NewBookingDialogState extends State<NewBookingDialog> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // mock list of available times
  final List<TimeOfDay> _availableTimes = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 17, minute: 30),
    const TimeOfDay(hour: 18, minute: 30),
    const TimeOfDay(hour: 19, minute: 30),
  ];

  // function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        // get the current theme
        final ThemeData theme = Theme.of(context);
        return Theme(
          // override the theme for the date picker dialog
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme
                  .colorScheme
                  .secondary, // header background color - using secondary as a base for selected day
              onPrimary: theme
                  .colorScheme
                  .primary, // header text color (e.g., "SELECT DATE") - making it black as per selected day text
              surface: theme.colorScheme.surface, // main dialog background
              onSurface: theme
                  .colorScheme
                  .tertiary, // default text color for days, month/year
            ),
            // specific styling for the date picker
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor:
                  theme.colorScheme.secondary, // header background
              headerForegroundColor: theme
                  .colorScheme
                  .primary, // header text (e.g. "SELECT DATE", selected date display)
              backgroundColor:
                  theme.colorScheme.surface, // background of the calendar part
              // day text style
              dayStyle: TextStyle(color: theme.colorScheme.tertiary),
              // weekday text style (Mon, Tue, etc.)
              weekdayStyle: TextStyle(color: theme.colorScheme.tertiary),
              // year text style
              yearStyle: TextStyle(color: theme.colorScheme.tertiary),
              // current day decoration
              todayForegroundColor: WidgetStateProperty.all(
                theme.colorScheme.primary,
              ), // text color for today
              todayBackgroundColor: WidgetStateProperty.all(
                theme.colorScheme.onSurfaceVariant,
              ),
              todayBorder: BorderSide.none, // remove border if not needed
              // selected day decoration
              dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return theme
                      .colorScheme
                      .primary; // text color for selected day
                }
                return theme
                    .colorScheme
                    .tertiary; // default text color for other days
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return theme
                      .colorScheme
                      .secondary; // background for selected day
                }
                return null; // default background for other days
              }),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor:
                    theme.colorScheme.secondary, // button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                foregroundColor: theme.colorScheme.primary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // _selectTime method is removed as we are using a dropdown

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Dialog(
      surfaceTintColor: theme.colorScheme.onSurfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Crear nueva reserva', style: theme.textTheme.titleLarge),
            const SizedBox(height: 24.0),
            // date selection - remains unchanged
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'Seleccionar fecha'
                      // using DateFormat to display the date in a more readable format
                      : 'Fecha: ${DateFormat.yMMMMd('es').format(_selectedDate!)}',
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  style: TextButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Elegir',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // time selection - changed to DropdownButtonFormField
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // text takes available space on the left
                  child: Text(
                    _selectedTime == null
                        ? 'Seleccionar hora'
                        : 'Hora: ${_selectedTime!.format(context)}',
                  ),
                ),
                const SizedBox(width: 8), // spacing between text and dropdown
                Expanded(
                  // dropdown takes available space on the right
                  child: DropdownButtonFormField<TimeOfDay>(
                    decoration: InputDecoration(
                      // labelText: 'Hora', // labelText might be redundant if text is on the left
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: theme
                          .colorScheme
                          .secondary, // light background for dropdown
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ), // adjust padding
                    ),
                    isDense: true, // makes the dropdown more compact
                    value: _selectedTime,
                    items: _availableTimes.map((TimeOfDay time) {
                      return DropdownMenuItem<TimeOfDay>(
                        value: time,
                        child: Text(
                          time.format(context),
                          style: TextStyle(color: theme.colorScheme.primary),
                        ), // changed text color to primary
                      );
                    }).toList(),
                    onChanged: (TimeOfDay? newValue) {
                      setState(() {
                        _selectedTime = newValue;
                      });
                    },
                    hint: Text(
                      'Elegir',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ), // changed hint
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (_selectedDate != null && _selectedTime != null) {
                        // combine date and time
                        final DateTime finalDateTime = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                          _selectedTime!.hour,
                          _selectedTime!.minute,
                        );
                        // TODO: use finalDateTime to create the booking
                        print('Reserva para: $finalDateTime');
                        Navigator.of(
                          context,
                        ).pop(finalDateTime); // pass the selected datetime back
                      } else {
                        // show an error or prompt to select date and time
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, selecciona fecha y hora.',
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Guardar',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
