import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class BarcodeLabelPrint
{

  Future<void> printBarcodeLabelA4(String barcodeData, String fileName, String finalPrice,
      String manufacturingDate, String expiringDate, String color, String size) async
  {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [

                pw.SizedBox(height: 5),

                pw.Text(
                  'Price: ${finalPrice} Rs',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),

                pw.SizedBox(height: 5),

                pw.BarcodeWidget(
                  barcode: pw.Barcode.code128(),
                  data: barcodeData,
                  width: PdfPageFormat.a4.width * 0.6,
                  height: 80,
                ),

                pw.SizedBox(height: 5),

                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if(manufacturingDate.isNotEmpty)pw.Text(
                        'MFG: ${manufacturingDate}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.black,
                        ),
                      ),
                      if(expiringDate.isNotEmpty) pw.Text(
                        'EXP: ${expiringDate}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.black,
                        ),
                      ),
                    ]
                ),
                pw.SizedBox(height: 5),

                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if(color.isNotEmpty) pw.Text(
                        'Color: ${color}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.black,

                        ),
                      ),
                      if(size.isNotEmpty) pw.Text(
                        'Size: ${size}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.black,
                        ),
                      ),
                    ]
                ),
                pw.SizedBox(height: 5),
              ],
            )
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name: fileName,
      usePrinterSettings: true,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> printBarcodeLabelRollOn80(String barcodeData, String fileName, String finalPrice,
      String manufacturingDate, String expiringDate, String color, String size) async
  {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [

                pw.SizedBox(height: 3),

                pw.Text(
                  'Price: ${finalPrice} Rs',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),

                pw.SizedBox(height: 3),

                pw.BarcodeWidget(
                  barcode: pw.Barcode.code128(),
                  data: barcodeData,
                  width: PdfPageFormat.roll80.width * 0.6,
                  height: 40,
                ),

                pw.SizedBox(height: 3),

                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if(manufacturingDate.isNotEmpty)pw.Text(
                        'MFG: ${manufacturingDate}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.black,
                        ),
                      ),
                      if(expiringDate.isNotEmpty) pw.Text(
                        'EXP: ${expiringDate}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.black,
                        ),
                      ),
                    ]
                ),
                pw.SizedBox(height: 3),

                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if(color.isNotEmpty) pw.Text(
                        'Color: ${color}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.black,

                        ),
                      ),
                      if(size.isNotEmpty) pw.Text(
                        'Size: ${size}',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.black,
                        ),
                      ),
                    ]
                ),
                pw.SizedBox(height: 3),

              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name: fileName,
      usePrinterSettings: true,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> printBarcodeLabelRollOn57(String barcodeData, String fileName, String finalPrice,
      String manufacturingDate, String expiringDate, String color, String size) async
  {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (pw.Context context) {
          return  pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [

              pw.SizedBox(height: 3),

              pw.Text(
                'Price: ${finalPrice} Rs',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),

              pw.SizedBox(height: 3),

              pw.BarcodeWidget(
                barcode: pw.Barcode.code128(),
                data: barcodeData,
                width: PdfPageFormat.roll57.width * 0.6,
                height: 30,
              ),
              pw.SizedBox(height: 3),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if(manufacturingDate.isNotEmpty)pw.Text(
                      'MFG: ${manufacturingDate}',
                      style: pw.TextStyle(
                        fontSize: 6,
                        color: PdfColors.black,
                      ),
                    ),
                    if(expiringDate.isNotEmpty) pw.Text(
                      'EXP: ${expiringDate}',
                      style: pw.TextStyle(
                        fontSize: 6,
                        color: PdfColors.black,
                      ),
                    ),
                  ]
              ),
              pw.SizedBox(height: 3),

              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if(color.isNotEmpty) pw.Text(
                      'Color: ${color}',
                      style: pw.TextStyle(
                        fontSize: 6,
                        color: PdfColors.black,

                      ),
                    ),
                    if(size.isNotEmpty) pw.Text(
                      'Size: ${size}',
                      style: pw.TextStyle(
                        fontSize: 6,
                        color: PdfColors.black,
                      ),
                    ),
                  ]
              ),
              pw.SizedBox(height: 3),
            ],
          ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      name: fileName,
      usePrinterSettings: true,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}