
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/theme/app_color.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_style.dart';
import '../../../core/service/invoice/invoice_service.dart';
import '../model/order_model.dart';
import '../model/order_status.dart';
import '../provider/order_provider.dart';

class OrderTrackingPage extends ConsumerStatefulWidget {
  final String orderId;

  const OrderTrackingPage({super.key, required this.orderId});

  @override
  ConsumerState<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends ConsumerState<OrderTrackingPage> {
  bool _isGeneratingInvoice = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).startPolling();
    });
  }

  @override
  void dispose() {
    ref.read(orderProvider.notifier).stopPolling();
    super.dispose();
  }

  // ============================================================
  // GENERATE INVOICE & SHOW OPTIONS DIALOG
  // ============================================================

  Future<void> _generateAndShowInvoice(BuildContext context) async {
    if (_isGeneratingInvoice) {
      return;
    }

    final orders = ref.read(orderProvider);

    // Find the current order
    OrderModel? order;

    try {
      order = orders.firstWhere((o) => o.id == widget.orderId);
    } catch (e) {
      order = null;
    }

    if (order == null) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Order not found.')));

      return;
    }

    setState(() {
      _isGeneratingInvoice = true;
    });

    try {
      // ========================================================
      // GENERATE PDF LOCALLY
      // ========================================================

      final String invoicePath = await InvoiceService.generateInvoicePdf(
        orderId: order.id,
        productName: order.items.isNotEmpty
            ? order.items.map((item) => item.productName).join(', ')
            : 'Multiple Items',
        quantity: order.items.fold(0, (sum, item) => sum + item.quantity),
        price: order.price,
        deliveryDate: order.orderDate,
        receiverName: order.receiverName,
        contactNumber: order.contactNumber,
        deliveryAddress: order.deliveryAddress,
      );

      debugPrint('Invoice generated successfully');
      debugPrint('Invoice path: $invoicePath');

      if (!context.mounted) return;

      // ========================================================
      // SHOW DIALOG WITH VIEW & DOWNLOAD/SHARE OPTIONS
      // ========================================================
      _showInvoiceOptionsDialog(context, invoicePath);

    } catch (e) {
      debugPrint('Failed to generate invoice: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to generate invoice: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingInvoice = false;
        });
      }
    }
  }

  // ============================================================
  // INVOICE OPTIONS BOTTOM SHEET / DIALOG
  // ============================================================

  void _showInvoiceOptionsDialog(BuildContext context, String filePath) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice Ready',
                style: AppTextStyles.title.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'What would you like to do with your invoice?',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),

              // View Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.visibility_outlined, color: AppColors.primary),
                ),
                title: const Text('View Invoice'),
                subtitle: const Text('Open and preview PDF on device'),
                onTap: () async {
                  Navigator.pop(context);
                  await OpenFile.open(filePath);
                },
              ),
              const Divider(),

              // Download / Share Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.download_outlined, color: AppColors.primary),
                ),
                title: const Text('Download / Share File'),
                subtitle: const Text('Save to files or share externally'),
                onTap: () async {
                  Navigator.pop(context);
                  await Share.shareXFiles(
                    [XFile(filePath)],
                    text: 'Here is your MyAnimal Order Invoice.',
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);

    // ==========================================================
    // FIND ORDER
    // ==========================================================

    final order = orders.firstWhere(
          (o) => o.id == widget.orderId,
      orElse: () => throw Exception('Order not found'),
    );

    // ==========================================================
    // ORDER STATUS LIST
    // ==========================================================

    final statusList = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.packed,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final currentStepIndex = statusList.indexOf(order.status);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        title: Text('Track Order', style: AppTextStyles.title),
        elevation: 0,
        backgroundColor: Colors.white,
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // HEADER
            // ==================================================
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  // ORDER ID + DATE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Order ID #${order.id}',
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          DateFormat(
                            'dd MMM yyyy, hh:mm a',
                          ).format(order.orderDate),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),

                  // TOTAL
                  Text(
                    '₹${order.price.toStringAsFixed(0)}',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ==================================================
            // PRODUCTS
            // ==================================================
            Text('Items Ordered', style: AppTextStyles.title),

            const SizedBox(height: AppSpacing.sm),

            Container(
              padding: const EdgeInsets.all(AppSpacing.md),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                children: order.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),

                    child: Row(
                      children: [
                        // PRODUCT IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),

                          child: Image.network(
                            item.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,

                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey.shade200,

                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: AppSpacing.md),

                        // PRODUCT DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                item.productName,
                                style: AppTextStyles.bodyMedium,

                                maxLines: 1,

                                overflow: TextOverflow.ellipsis,
                              ),

                              Text(
                                'Qty: ${item.quantity} | ₹${item.price.toStringAsFixed(0)}',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ==================================================
            // DELIVERY DETAILS
            // ==================================================
            Text('Delivery Details', style: AppTextStyles.title),

            const SizedBox(height: AppSpacing.sm),

            Container(
              padding: const EdgeInsets.all(AppSpacing.md),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                children: [
                  _buildDetailRow(Icons.person_outline, order.receiverName),

                  _buildDetailRow(Icons.phone_outlined, order.contactNumber),

                  _buildDetailRow(
                    Icons.location_on_outlined,
                    order.deliveryAddress,
                    isMultiline: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ==================================================
            // ORDER PROGRESS
            // ==================================================
            Text('Order Progress', style: AppTextStyles.title),

            const SizedBox(height: AppSpacing.md),

            ListView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              itemCount: statusList.length,

              itemBuilder: (context, index) {
                final targetStatus = statusList[index];

                return _TrackingStep(
                  title: targetStatus.title,

                  subtext: _getStatusSubtext(targetStatus, order.orderDate),

                  isCompleted: index <= currentStepIndex,

                  isCurrent: index == currentStepIndex,

                  isLast: index == statusList.length - 1,
                );
              },
            ),

            // ==================================================
            // INVOICE BUTTON
            // ==================================================
            if (order.status == OrderStatus.delivered) ...[
              const SizedBox(height: AppSpacing.lg),

              SizedBox(
                width: double.infinity,

                height: 50,

                child: FilledButton.icon(
                  onPressed: _isGeneratingInvoice
                      ? null
                      : () => _generateAndShowInvoice(context),

                  icon: _isGeneratingInvoice
                      ? const SizedBox(
                    width: 20,
                    height: 20,

                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.picture_as_pdf_outlined),

                  label: Text(
                    _isGeneratingInvoice
                        ? 'Generating Invoice...'
                        : 'Download Invoice',
                  ),

                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _buildDetailRow(
      IconData icon,
      String text, {
        bool isMultiline = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),

          const SizedBox(width: AppSpacing.sm),

          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium,

              maxLines: isMultiline ? 3 : 1,

              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS SUBTEXT
  // ============================================================

  String _getStatusSubtext(OrderStatus status, DateTime orderDate) {
    final fmt = DateFormat('dd MMM, hh:mm a');

    switch (status) {
      case OrderStatus.pending:
        return 'Order placed at ${fmt.format(orderDate)}';

      case OrderStatus.confirmed:
        return 'Seller confirmed your order';

      case OrderStatus.packed:
        return 'Package is being prepared';

      case OrderStatus.shipped:
        return 'Dispatched from warehouse';

      case OrderStatus.delivered:
        return 'Arrived at your doorstep';

      default:
        return '';
    }
  }
}

// ================================================================
// TRACKING STEP
// ================================================================

class _TrackingStep extends StatelessWidget {
  final String title;
  final String subtext;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const _TrackingStep({
    required this.title,
    required this.subtext,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // ========================================================
        // TIMELINE ICON
        // ========================================================
        Column(
          children: [
            Container(
              width: 24,
              height: 24,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: isCompleted ? AppColors.primary : Colors.grey.shade300,
              ),

              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 40,

                color: isCompleted ? AppColors.primary : Colors.grey.shade300,
              ),
          ],
        ),

        const SizedBox(width: AppSpacing.md),

        // ========================================================
        // STATUS TEXT
        // ========================================================
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: AppTextStyles.label.copyWith(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtext,

                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}