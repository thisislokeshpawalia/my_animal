import "package:flutter/foundation.dart";
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class BrevoEmailService {
  // ============================================================
  // BREVO CONFIGURATION
  // ============================================================

  // IMPORTANT:
  // Generate a NEW API key in your Brevo account.
  //
  // The previous API key was exposed and should be revoked.
  //
  // For production:
  // DO NOT put this API key inside Flutter.
  // Use your backend instead.
  static const String _apiKey = 'YOUR_BREVO_API_KEY';

  // This email must be verified in Brevo as a sender.
  static const String _senderEmail = 'lokeshpawalia@gmail.com';

  static const String _senderName = 'MyAnimal';

  // ============================================================
  // TEST BREVO API CONNECTION
  // ============================================================

  static Future<void> testBrevoConnection() async {
    try {
      final Uri url = Uri.parse('https://api.brevo.com/v3/account');

      final response = await http.get(
        url,
        headers: {'accept': 'application/json', 'api-key': _apiKey},
      );

      debugPrint('Brevo test status: ${response.statusCode}');

      debugPrint('Brevo test response: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Brevo API connection successful.');
      } else {
        debugPrint('Brevo API connection failed.');
      }
    } catch (e) {
      debugPrint('Brevo connection test error: $e');
    }
  }

  // ============================================================
  // SEND DELIVERY EMAIL
  // ============================================================

  static Future<void> sendDeliveryEmail({
    required String customerEmail,
    required String customerName,
    required String orderId,
    required String invoicePath,
  }) async {
    try {
      // ========================================================
      // VALIDATE CUSTOMER EMAIL
      // ========================================================

      final String email = customerEmail.trim();

      if (email.isEmpty) {
        throw Exception('Customer email is empty.');
      }

      // ========================================================
      // VALIDATE INVOICE PATH
      // ========================================================

      final String path = invoicePath.trim();

      if (path.isEmpty) {
        throw Exception('Invoice path is empty.');
      }

      debugPrint('Checking invoice file:');

      debugPrint(path);

      // ========================================================
      // CREATE FILE OBJECT
      // ========================================================

      final File invoiceFile = File(path);

      // ========================================================
      // CHECK FILE EXISTS
      // ========================================================

      final bool fileExists = await invoiceFile.exists();

      if (!fileExists) {
        throw Exception('Invoice file does not exist: $path');
      }

      // ========================================================
      // READ PDF
      // ========================================================

      final List<int> invoiceBytes = await invoiceFile.readAsBytes();

      debugPrint(
        'Invoice file size: '
        '${invoiceBytes.length} bytes',
      );

      if (invoiceBytes.isEmpty) {
        throw Exception('Invoice PDF is empty.');
      }

      // ========================================================
      // CONVERT PDF TO BASE64
      // ========================================================

      final String invoiceBase64 = base64Encode(invoiceBytes);

      // ========================================================
      // BREVO API URL
      // ========================================================

      final Uri url = Uri.parse('https://api.brevo.com/v3/smtp/email');

      // ========================================================
      // SEND EMAIL
      // ========================================================

      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'api-key': _apiKey,
          'content-type': 'application/json',
        },
        body: jsonEncode({
          // ====================================================
          // SENDER
          // ====================================================
          'sender': {'name': _senderName, 'email': _senderEmail},

          // ====================================================
          // CUSTOMER
          // ====================================================
          'to': [
            {'email': email, 'name': customerName},
          ],

          // ====================================================
          // SUBJECT
          // ====================================================
          'subject': 'Your MyAnimal order has been successfully delivered! 📦',

          // ====================================================
          // EMAIL CONTENT (Redesigned & Clean)
          // ====================================================
          'htmlContent':
              '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #F9F9F9;
      color: #333333;
      margin: 0;
      padding: 0;
    }
    .email-wrapper {
      width: 100%;
      table-layout: fixed;
      background-color: #F9F9F9;
      padding: 20px 0;
    }
    .email-content {
      max-width: 600px;
      margin: 0 auto;
      background-color: #FFFFFF;
      border-radius: 8px;
      overflow: hidden;
      border: 1px solid #E0E0E0;
    }
    .email-header {
      background-color: #2E7D32;
      color: #FFFFFF;
      padding: 24px;
      text-align: center;
    }
    .email-header h1 {
      margin: 0;
      font-size: 24px;
    }
    .email-body {
      padding: 24px;
    }
    .order-box {
      background-color: #F1F8E9;
      border-left: 4px solid #2E7D32;
      padding: 12px 16px;
      margin: 20px 0;
      border-radius: 4px;
    }
    .email-footer {
      background-color: #F4F4F4;
      color: #777777;
      padding: 16px;
      text-align: center;
      font-size: 12px;
    }
  </style>
</head>
<body>
  <table class="email-wrapper" width="100%" cellpadding="0" cellspacing="0">
    <tr>
      <td align="center">
        <table class="email-content" width="100%" cellpadding="0" cellspacing="0">
          
          <!-- Header -->
          <tr>
            <td class="email-header">
              <h1>MyAnimal</h1>
              <p style="margin: 4px 0 0 0; font-size: 13px; color: #E8F5E9;">Your Trusted Pet Care Partner</p>
            </td>
          </tr>

          <!-- Body -->
          <tr>
            <td class="email-body">
              <h2 style="color: #2E7D32; margin-top: 0;">Order Delivered Successfully!</h2>
              <p>Hello <strong>$customerName</strong>,</p>
              <p>Great news! Your recent order with MyAnimal has been successfully delivered to your shipping address.</p>
              
              <div class="order-box">
                <p style="margin: 0;"><strong>Order ID:</strong> #$orderId</p>
              </div>

              <p>Your official invoice PDF has been securely attached to this email for your records.</p>
              
              <p>Thank you for choosing MyAnimal to look after your pet's needs. If you have any questions or require assistance, please feel free to reach out to us.</p>
              
              <p style="margin-top: 24px;">
                Warm regards,<br>
                <strong>The MyAnimal Team</strong>
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td class="email-footer">
              <p style="margin: 0;">&copy; ${DateTime.now().year} MyAnimal. All rights reserved.</p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
''',

          // ====================================================
          // PDF ATTACHMENT
          // ====================================================
          'attachment': [
            {'content': invoiceBase64, 'name': 'invoice_$orderId.pdf'},
          ],
        }),
      );

      // ========================================================
      // CHECK BREVO RESPONSE
      // ========================================================

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Brevo email failed.\n'
          'Status code: '
          '${response.statusCode}\n'
          'Response: '
          '${response.body}',
        );
      }

      // ========================================================
      // SUCCESS
      // ========================================================

      debugPrint('Delivery email sent successfully.');

      debugPrint('Recipient: $email');

      debugPrint('Order ID: $orderId');

      debugPrint('Invoice attached: $path');
    } catch (e) {
      debugPrint('Failed to send delivery email: $e');

      rethrow;
    }
  }
}
