import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButtonWidget {

  ElevatedButton ButtonField(BuildContext context, String buttonText, VoidCallback function )
  {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            MediaQuery
                .of(context)
                .size
                .width * 0.6, // Minimum width
            MediaQuery
                .of(context)
                .size
                .height * 0.06, // Minimum height
          ),
          maximumSize: Size(
            MediaQuery
                .of(context)
                .size
                .width * 0.9, // Maximum width
            MediaQuery
                .of(context)
                .size
                .height * 0.1, // Maximum height
          ),
          backgroundColor: Color(0xFFABE6B2),
          // Background color
          foregroundColor: Colors.black,
          // Text color
          shadowColor: Colors.black,
          // Shadow color
          elevation: 4,
          // Elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
        ),
        onPressed: function,
        child: Text(
          buttonText,
          style:
          TextStyle(fontSize: MediaQuery
              .of(context)
              .size
              .height * 0.025,
          fontWeight: FontWeight.bold),
        ),
    );
  }

  ElevatedButton GoToDashboardButtonField(BuildContext context, String buttonText, VoidCallback function )
  {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          MediaQuery
              .of(context)
              .size
              .width * 0.6, // Minimum width
          MediaQuery
              .of(context)
              .size
              .height * 0.06, // Minimum height
        ),
        maximumSize: Size(
          MediaQuery
              .of(context)
              .size
              .width * 0.9, // Maximum width
          MediaQuery
              .of(context)
              .size
              .height * 0.1, // Maximum height
        ),
        backgroundColor: Colors.grey.withOpacity(0.2),
        // Background color
        foregroundColor: Colors.black,
        // Text color
        shadowColor: Colors.grey.withOpacity(0.2),
        // Shadow color
        elevation: 4,
        // Elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
      onPressed: function,
      child: Text(
        buttonText,
        style:
        TextStyle(fontSize: MediaQuery
            .of(context)
            .size
            .height * 0.025,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

