import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceService {
  /// Generates a branded invoice PDF and saves it
  /// inside the app's local documents directory.
  ///
  /// Returns the FULL PATH of the generated PDF.
  static Future<String> generateInvoicePdf({
    required String orderId,
    required String productName,
    required int quantity,
    required double price,
    required DateTime deliveryDate,
    required String receiverName,
    required String contactNumber,
    required String deliveryAddress,
  }) async {
    try {
      final pdf = pw.Document();

      // App Theme Colors (Matching a clean pet-care aesthetic)
      const primaryColor = PdfColor.fromInt(0xFF2E7D32); // Deep Forest Green
      const secondaryColor = PdfColor.fromInt(0xFFF1F8E9); // Light Green Tint
      const textColor = PdfColor.fromInt(0xFF333333);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER WITH BRANDING
                  // ==================================================
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'MyAnimal',
                            style: pw.TextStyle(
                              fontSize: 28,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Your Trusted Pet Care Partner',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: const pw.BoxDecoration(
                          color: secondaryColor,
                          borderRadius: pw.BorderRadius.all(
                            pw.Radius.circular(4),
                          ),
                        ),
                        child: pw.Text(
                          'INVOICE',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 20),
                  pw.Divider(color: primaryColor, thickness: 1.5),
                  pw.SizedBox(height: 15),

                  // ==================================================
                  // ORDER & CUSTOMER DETAILS SECTION
                  // ==================================================
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      // Customer Info
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Billed To:',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text('Name: $receiverName',
                                style: const pw.TextStyle(color: textColor)),
                            pw.Text('Phone: $contactNumber',
                                style: const pw.TextStyle(color: textColor)),
                            pw.Text('Address: $deliveryAddress',
                                style: const pw.TextStyle(color: textColor)),
                          ],
                        ),
                      ),
                      // Order Info
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Order Details:',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text('Order ID: $orderId',
                              style: const pw.TextStyle(color: textColor)),
                          pw.Text(
                            'Delivery Date: '
                                '${deliveryDate.day}/'
                                '${deliveryDate.month}/'
                                '${deliveryDate.year}',
                            style: const pw.TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 30),

                  // ==================================================
                  // PRODUCT TABLE
                  // ==================================================
                  pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey300,
                      width: 0.5,
                    ),
                    children: [
                      // HEADER ROW
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: secondaryColor,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(
                              'Product Description',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(
                              'Quantity',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: primaryColor,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(
                              'Total',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: primaryColor,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),

                      // PRODUCT ROW
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(productName,
                                style: const pw.TextStyle(color: textColor)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(quantity.toString(),
                                textAlign: pw.TextAlign.center,
                                style: const pw.TextStyle(color: textColor)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(
                              'INR ${price.toStringAsFixed(2)}',
                              textAlign: pw.TextAlign.right,
                              style: const pw.TextStyle(color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 20),

                  // ==================================================
                  // GRAND TOTAL
                  // ==================================================
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          'Grand Total: ',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        pw.Text(
                          'INR ${price.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.Spacer(),

                  // ==================================================
                  // FOOTER
                  // ==================================================
                  pw.Divider(color: PdfColors.grey400),
                  pw.SizedBox(height: 10),
                  pw.Center(
                    child: pw.Text(
                      'Thank you for shopping with MyAnimal! Give your pets the best care.',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // ============================================================
      // FILE STORAGE HANDLING
      // ============================================================
      final directory = await getApplicationDocumentsDirectory();
      final invoiceDirectory = Directory('${directory.path}/invoices');

      if (!await invoiceDirectory.exists()) {
        await invoiceDirectory.create(recursive: true,);
      }

      final file = File('${invoiceDirectory.path}/invoice_$orderId.pdf');
      final pdfBytes = await pdf.save();

      await file.writeAsBytes(pdfBytes, flush: true);

      if (!await file.exists()) {
        throw Exception('Invoice file was not created.');
      }

      return file.path;
    } catch (e) {
      rethrow;
    }
  }
}