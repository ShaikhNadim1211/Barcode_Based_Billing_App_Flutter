import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker
{

  Future<DateTime?> getDate(BuildContext context, DateTime initialDate, DateTime firstDate, DateTime lastDate) async
  {
    final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC8EFD1),
              onPrimary: Colors.black,
              secondary: Color(0xFFC8EFD1),
              onSecondary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.black), // Set text color to black
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null)
    {
        return selectedDate;
    }
    return null;
  }
}