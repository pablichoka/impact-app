import 'package:impact/models/user.dart';

class Booking {
  DateTime startTime;
  DateTime endTime;
  User user;

  Booking({
    required this.startTime,
    required this.endTime,
    required this.user,
  });
}