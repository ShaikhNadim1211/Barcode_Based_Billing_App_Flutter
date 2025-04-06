import 'dart:math';

import 'package:crypto/crypto.dart';
import 'dart:convert';

class ShopOwnerDocumentIdManage
{
  String generateOwnerDocumentId(String userName, String phoneNumber, String email)
  {
    final String firstPhoneNumber=phoneNumber.substring(0,4);
    final String lastPhoneNumber=phoneNumber.substring(5,9);

    final dataToHash = '$firstPhoneNumber|$userName|$lastPhoneNumber|$email';

    final bytes = utf8.encode(dataToHash); // Convert to bytes
    final hash = sha256.convert(bytes); // Generate hash

    return hash.toString();
  }

  String userNameChecking(String userName)
  {
    final dataToHash = '$userName';

    final bytes = utf8.encode(dataToHash);
    final hash = sha256.convert(bytes);

    return hash.toString();
  }

  String generatePasswordForEmailVerification(String email)
  {

    final dataToHash = '$email';

    final bytes = utf8.encode(dataToHash); // Convert to bytes
    final hash = sha256.convert(bytes); // Generate hash

    return hash.toString();
  }

  String generateShopDocumentId(String userName, String shopName)
  {
    final dataToHash = '$userName|$shopName';

    final bytes = utf8.encode(dataToHash); // Convert to bytes
    final hash = sha256.convert(bytes); // Generate hash

    return hash.toString();
  }

  String getProductId()
  {
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    String formattedTime = "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    return "PROD-$formattedDate-$formattedTime";
  }

  String getCustomerId()
  {
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    String formattedTime = "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    return "CUST-$formattedDate-$formattedTime";
  }

  String getInvoiceId()
  {
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    String formattedTime = "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    return "INV-$formattedDate-$formattedTime";
  }

  String getWorkerId()
  {
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    String formattedTime = "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    return "WOR-$formattedDate-$formattedTime";
  }

  String workerPasswordGenerate()
  {
    const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    const String allChars = uppercase + lowercase + numbers + specialChars;

    final Random random = Random();

    // Ensure at least one character from each category
    String password = '';
    password += uppercase[random.nextInt(uppercase.length)];
    password += lowercase[random.nextInt(lowercase.length)];
    password += numbers[random.nextInt(numbers.length)];
    password += specialChars[random.nextInt(specialChars.length)];

    // Fill the rest of the password to meet the minimum length requirement
    for (int i = password.length; i < 6; i++) {
      password += allChars[random.nextInt(allChars.length)];
    }

    // Shuffle the password to ensure randomness
    List<String> passwordChars = password.split('');
    passwordChars.shuffle(random);

    return passwordChars.join();
  }
}