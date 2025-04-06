import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInputFieldWidget
{

  Container NormalInputField(BuildContext context,TextEditingController value, String hint, dynamic prefixIcon, TextInputType inputType, String labelText)
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        keyboardType: inputType,
        controller: value,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          prefixIcon: prefixIcon,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.black
          ),
        ),
      ),
    );
  }

  Container PasswordInputField(BuildContext context,TextEditingController value, String hint, dynamic prefixIcon, bool passwordVisibility, IconButton suffixIcon, String labelText )
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        maxLength: 16,
        obscureText: passwordVisibility,
        obscuringCharacter: "*",
        controller: value,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
              color: Colors.black
          ),
          labelText: labelText,
        ),
      ),
    );
  }

  Container NormalInputFieldWithOnChange(BuildContext context,TextEditingController value, String hint, dynamic prefixIcon, TextInputType inputType, dynamic suffixIcon, void onChanged(String value),  bool enabled, int maxLength, String labelText)
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        maxLength: maxLength,
        enabled: enabled,
        keyboardType: inputType,
        controller: value,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: labelText,
          labelStyle: TextStyle(
              color: Colors.black
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Container PasswordInputFieldWithOnChange(BuildContext context,TextEditingController value, String hint, dynamic prefixIcon, bool passwordVisibility, IconButton suffixIcon, void onChanged(String value), String labelText  )
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        maxLength: 16,
        obscureText: passwordVisibility,
        obscuringCharacter: "*",
        controller: value,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
              color: Colors.black
          ),
          labelText: labelText,
        ),
        onChanged: onChanged,
      ),
    );
  }


  Container otpInputField(BuildContext context,TextEditingController value, String hint, TextInputType inputType, Widget suffixIcon)
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        maxLength: 6,
        keyboardType: inputType,
        controller: value,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
              color: Colors.black
          ),
          labelText: "OTP"
        ),
      ),
    );
  }

  Container MultilineInputFieldWithOnChange(BuildContext context,TextEditingController value, String hint, dynamic prefixIcon, TextInputType inputType, dynamic suffixIcon, void onChanged(String value),  bool enabled, int maxLength, String labelText)
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        maxLength: maxLength,
        maxLines: null,
        minLines: 1,
        enabled: enabled,
        keyboardType: inputType,
        controller: value,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: labelText,
          labelStyle: TextStyle(
              color: Colors.black
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Container SearchInputFieldWithOnChange(BuildContext context,TextEditingController value, String hint, dynamic prefixIcon, TextInputType inputType, void onChanged(String value), int maxLength)
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        maxLength: maxLength,
        keyboardType: inputType,
        controller: value,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          prefixIcon: prefixIcon,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Container DateInputField(BuildContext context,TextEditingController value, String hint, dynamic suffixIcon, String labelText)
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        readOnly: true,
        controller: value,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          suffixIcon: suffixIcon,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.black
          )
        ),
      ),
    );
  }

  Container WorkerManageDisplayPasswordInputField(BuildContext context,TextEditingController value, String hint, dynamic prefixIcon, bool passwordVisibility, IconButton suffixIcon )
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        readOnly: true,
        maxLength: 16,
        obscureText: passwordVisibility,
        obscuringCharacter: "*",
        controller: value,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
              color: Colors.black
          ),
          labelText: "Password",
        ),
      ),
    );
  }
  Container NormalInputFieldReadOnly(BuildContext context,TextEditingController value, String hint, dynamic prefixIcon, String labelText)
  {
    return Container(
      width:MediaQuery.of(context).size.height * 0.8,
      child: TextField(
        controller: value,
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Colors.black,
              width: 5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(
              color: Color(0xFFABE6B2),
              width: 5,
            ),
          ),
          hintText: hint,
          prefixIcon: prefixIcon,
          labelText: labelText,
          labelStyle: TextStyle(
              color: Colors.black
          ),
        ),
      ),
    );
  }
}