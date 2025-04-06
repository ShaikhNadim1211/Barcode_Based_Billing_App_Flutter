
import 'dart:math';

class BarcodeNumberGenerator
{
  String generateBarcode()
  {
    const length = 12;
    Random random = Random();
    String barcode = '';

    for (int i = 0; i < length; i++)
    {
      barcode += random.nextInt(10).toString();
    }
    return barcode;
  }
}