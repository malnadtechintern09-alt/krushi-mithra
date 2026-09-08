import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../marketplace/presentation/providers/marketplace_provider.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/order.dart';
import '../providers/bookings_orders_provider.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_translations.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  static const String _hiddenHistoryStorageKey = 'krushi_hidden_history_ids';

  String _selectedStatusFilter = 'All';
  final Set<String> _hiddenHistoryIds = {};

  @override
  void initState() {
    super.initState();
    _loadHiddenHistoryIds();
  }

  Future<void> _loadHiddenHistoryIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hiddenList = prefs.getStringList(_hiddenHistoryStorageKey) ?? [];
      if (mounted && hiddenList.isNotEmpty) {
        setState(() {
          _hiddenHistoryIds.addAll(hiddenList);
        });
      }
    } catch (_) {}
  }

  Future<void> _saveHiddenHistoryIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_hiddenHistoryStorageKey, _hiddenHistoryIds.toList());
    } catch (_) {}
  }

  void _showClearHistoryConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.cleaning_services_rounded, color: AppColors.primaryGreen),
            SizedBox(width: 10),
            Text('Clear History & Filters?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'This will reset your status filters back to "All" and restore any hidden activity cards in your history feed.',
          style: TextStyle(fontSize: 13, color: AppColors.warmDarkBrown),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
            label: const Text('Clear Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _selectedStatusFilter = 'All';
                _hiddenHistoryIds.clear();
              });
              _saveHiddenHistoryIds();
              ref.invalidate(userBookingsProvider);
              ref.invalidate(userOrdersProvider);
              ref.invalidate(marketplaceProductsProvider);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Activity history filters & view cleared!'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(userBookingsProvider);
    final ordersAsync = ref.watch(userOrdersProvider);
    final productsAsync = ref.watch(marketplaceProductsProvider);
    final selectedLang = ref.watch(languageProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.warmBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ref.tr('my_orders'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
              Text(
                'All rentals, worker hires, orders & sales',
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.cleaning_services_rounded, color: Colors.white),
              tooltip: 'Clear History & Filters',
              onPressed: _showClearHistoryConfirmationDialog,
            ),
            IconButton(
              icon: const Icon(Icons.home_rounded, color: Colors.white),
              tooltip: 'Return to Home',
              onPressed: () => context.go('/'),
            ),
            const SizedBox(width: 4),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.accentGold,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: '📋 All History'),
              Tab(text: '🚜 Machinery & Workers'),
              Tab(text: '🛒 Store Purchases'),
              Tab(text: '🌾 My Produce Sales'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Status Quick Filter Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'Filter Status:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...['All', 'Confirmed', 'Completed', 'In Progress'].map((status) {
                            final isSelected = _selectedStatusFilter == status;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: ChoiceChip(
                                label: Text(status),
                                selected: isSelected,
                                selectedColor: AppColors.primaryGreen,
                                backgroundColor: AppColors.chipBackground,
                                labelStyle: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppColors.warmDarkBrown,
                                ),
                                onSelected: (_) {
                                  setState(() {
                                    _selectedStatusFilter = status;
                                  });
                                },
                              ),
                            );
                          }),
                          if (_selectedStatusFilter != 'All' || _hiddenHistoryIds.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: TextButton.icon(
                                icon: const Icon(Icons.clear_all_rounded, size: 16, color: AppColors.error),
                                label: const Text('Clear', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.error)),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedStatusFilter = 'All';
                                    _hiddenHistoryIds.clear();
                                  });
                                  _saveHiddenHistoryIds();
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Status filters and history view cleared.'),
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(userBookingsProvider);
                  ref.invalidate(userOrdersProvider);
                  ref.invalidate(marketplaceProductsProvider);
                },
                child: TabBarView(
                  children: [
                    // Tab 1: All Combined History Feed
                    _buildAllCombinedHistoryTab(bookingsAsync, ordersAsync),

                    // Tab 2: Machine & Worker Bookings History
                    _buildBookingsTab(bookingsAsync),

                    // Tab 3: Agro Store Purchases History
                    _buildOrdersTab(ordersAsync),

                    // Tab 4: Produce Sales & Listings History
                    _buildProduceSalesTab(productsAsync),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: ALL COMBINED HISTORY FEED ---
  Widget _buildAllCombinedHistoryTab(AsyncValue<List<Booking>> bookingsAsync, AsyncValue<List<Order>> ordersAsync) {
    if (bookingsAsync.isLoading || ordersAsync.isLoading) {
      return const LoadingIndicator();
    }

    final bookings = bookingsAsync.value ?? [];
    final orders = ordersAsync.value ?? [];

    if (bookings.isEmpty && orders.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.history_rounded,
        title: 'No Activity History Yet',
        description: 'Your machine rentals, worker bookings & store purchases will appear here.',
      );
    }

    final filteredBookings = bookings.where((b) {
      if (_hiddenHistoryIds.contains(b.id)) return false;
      if (_selectedStatusFilter == 'All') return true;
      return b.bookingStatus.toLowerCase().contains(_selectedStatusFilter.toLowerCase());
    }).toList();

    final filteredOrders = orders.where((o) {
      if (_hiddenHistoryIds.contains(o.id)) return false;
      if (_selectedStatusFilter == 'All') return true;
      return o.orderStatus.toLowerCase().contains(_selectedStatusFilter.toLowerCase());
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (filteredBookings.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'RENTALS & WORKER BOOKINGS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5),
            ),
          ),
          ...filteredBookings.map((b) => _buildBookingCard(b)),
          const SizedBox(height: 16),
        ],

        if (filteredOrders.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'STORE PURCHASES & ORDERS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5),
            ),
          ),
          ...filteredOrders.map((o) => _buildOrderCard(o)),
        ],
      ],
    );
  }

  // --- TAB 2: MACHINERY & WORKERS HISTORY ---
  Widget _buildBookingsTab(AsyncValue<List<Booking>> bookingsAsync) {
    return bookingsAsync.when(
      data: (bookings) {
        final filtered = bookings.where((b) {
          if (_hiddenHistoryIds.contains(b.id)) return false;
          if (_selectedStatusFilter == 'All') return true;
          return b.bookingStatus.toLowerCase().contains(_selectedStatusFilter.toLowerCase());
        }).toList();

        if (filtered.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.calendar_month_outlined,
            title: 'No Matching Bookings',
            description: 'No bookings found for the selected status filter.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (ctx, i) => _buildBookingCard(filtered[i]),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  // --- TAB 3: AGRO STORE PURCHASES HISTORY ---
  Widget _buildOrdersTab(AsyncValue<List<Order>> ordersAsync) {
    return ordersAsync.when(
      data: (orders) {
        final filtered = orders.where((o) {
          if (_hiddenHistoryIds.contains(o.id)) return false;
          if (_selectedStatusFilter == 'All') return true;
          return o.orderStatus.toLowerCase().contains(_selectedStatusFilter.toLowerCase());
        }).toList();

        if (filtered.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.local_shipping_outlined,
            title: 'No Matching Orders',
            description: 'No store purchases found for the selected status filter.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (ctx, i) => _buildOrderCard(filtered[i]),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  // --- TAB 4: MY PRODUCE SALES & LISTINGS ---
  Widget _buildProduceSalesTab(AsyncValue<dynamic> productsAsync) {
    return productsAsync.when(
      data: (productsList) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.warmBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.storefront_rounded, color: AppColors.primaryGreen, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Produce Listings & Sales',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.warmDarkBrown),
                          ),
                          const Text(
                            'Manage your listed Arecanut, Pepper & Coffee sales',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () => context.push('/marketplace/create'),
                      child: const Text('Post Item', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            _buildSampleProduceListingCard(
              title: 'Supreme Arecanut (Rashi Quality - Dried)',
              category: 'Arecanut',
              price: '₹480 / kg',
              quantity: '500 kg available',
              seller: 'Bharath Poojary (You)',
              phone: '+91 8904089051',
              status: 'Active Sale',
              imageUrl: 'https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800',
            ),
            const SizedBox(height: 10),
            _buildSampleProduceListingCard(
              title: 'Black Pepper (Grade A Malabar Coast)',
              category: 'Pepper',
              price: '₹550 / kg',
              quantity: '200 kg available',
              seller: 'Bharath Poojary (You)',
              phone: '+91 8904089051',
              status: 'Active Sale',
              imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=800',
            ),
          ],
        );
      },
      loading: () => const LoadingIndicator(),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildSampleProduceListingCard({
    required String title,
    required String category,
    required String price,
    required String quantity,
    required String seller,
    required String phone,
    required String status,
    required String imageUrl,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.warmBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                  ),
                ),
                StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AppImage(url: imageUrl, width: 65, height: 65, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(quantity, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.success)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Seller: $seller', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                OutlinedButton.icon(
                  icon: const Icon(Icons.phone_rounded, color: AppColors.primaryGreen, size: 14),
                  label: const Text('Inquiries', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                  onPressed: () => UrlLauncherHelper.makePhoneCall(phone),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- BOOKING CARD WIDGET WITH HISTORY DETAILS SHEET ---
  Widget _buildBookingCard(Booking b) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.warmBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showHistoryDetailModalSheet(context, booking: b),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      b.bookingType.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      StatusBadge(status: b.bookingStatus),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _hiddenHistoryIds.add(b.id);
                          });
                          _saveHiddenHistoryIds();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cleared "${b.targetTitle}" from history view.'),
                              action: SnackBarAction(
                                label: 'Undo',
                                textColor: AppColors.accentGold,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  setState(() {
                                    _hiddenHistoryIds.remove(b.id);
                                  });
                                  _saveHiddenHistoryIds();
                                },
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AppImage(
                      url: b.targetImageUrl,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.targetTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dates: ${Formatters.date(b.startDate)} - ${Formatters.date(b.endDate)}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Location: ${b.serviceLocation}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                      Text(
                        Formatters.currency(b.totalAmount),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.success),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.info_outline_rounded, size: 14),
                        label: const Text('Details', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                        onPressed: () => _showHistoryDetailModalSheet(context, booking: b),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 14),
                        label: const Text('Contact', style: TextStyle(fontSize: 11, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whatsappGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        onPressed: () {
                          UrlLauncherHelper.showWhatsAppConfirmationBottomSheet(
                            context: context,
                            phoneNumber: b.providerPhone,
                            recipientName: b.providerName,
                            category: 'Service Booking',
                            itemTitle: b.targetTitle,
                            itemId: b.id,
                            itemType: 'bookings',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ORDER CARD WIDGET WITH HISTORY DETAILS SHEET ---
  Widget _buildOrderCard(Order o) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.warmBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showHistoryDetailModalSheet(context, order: o),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order #${o.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Row(
                    children: [
                      StatusBadge(status: o.orderStatus),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _hiddenHistoryIds.add(o.id);
                          });
                          _saveHiddenHistoryIds();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cleared Order #${o.id} from history view.'),
                              action: SnackBarAction(
                                label: 'Undo',
                                textColor: AppColors.accentGold,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  setState(() {
                                    _hiddenHistoryIds.remove(o.id);
                                  });
                                  _saveHiddenHistoryIds();
                                },
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Placed on: ${Formatters.dateTime(o.createdAt)}',
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 10),
              ...o.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.product.title} (x${item.quantity})',
                            style: const TextStyle(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Formatters.currency(item.totalPrice),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment: ${o.paymentMethod}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      Text(
                        Formatters.currency(o.totalAmount),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.success),
                      ),
                    ],
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.receipt_long_rounded, size: 14),
                    label: const Text('View Receipt', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                    onPressed: () => _showHistoryDetailModalSheet(context, order: o),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- INTERACTIVE HISTORY DETAILS & RECEIPT MODAL SHEET ---
  void _showHistoryDetailModalSheet(BuildContext context, {Booking? booking, Order? order}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.70,
          minChildSize: 0.5,
          maxChildSize: 0.90,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (booking != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Booking Receipt Details',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
                        ),
                        StatusBadge(status: booking.bookingStatus),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Booking Reference ID: #${booking.id}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 16),

                    // Target Item Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warmBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.warmBorder),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AppImage(url: booking.targetImageUrl, width: 70, height: 70, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(booking.targetTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text('Service Type: ${booking.bookingType.toUpperCase()}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                Text('Location: ${booking.serviceLocation}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Schedule & Provider Info
                    const Text('Provider & Schedule Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warmDarkBrown)),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.person, color: AppColors.primaryGreen)),
                      title: Text(booking.providerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('Phone: ${booking.providerPhone}', style: const TextStyle(fontSize: 12)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone, color: AppColors.primaryGreen),
                            onPressed: () => UrlLauncherHelper.makePhoneCall(booking.providerPhone),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat, color: AppColors.whatsappGreen),
                            onPressed: () => UrlLauncherHelper.openWhatsApp(
                              phoneNumber: booking.providerPhone,
                              message: UrlLauncherHelper.buildStructuredWhatsAppMessage(
                                category: 'Service Booking',
                                recipientName: booking.providerName,
                                itemTitle: booking.targetTitle,
                                itemId: booking.id,
                                itemType: 'bookings',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 20),

                    // Pricing Breakdown
                    const Text('Payment Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warmDarkBrown)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Booking Duration', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text('${Formatters.date(booking.startDate)} to ${Formatters.date(booking.endDate)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Paid', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
                        Text(Formatters.currency(booking.totalAmount), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.success)),
                      ],
                    ),
                  ],

                  if (order != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order Receipt Details',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
                        ),
                        StatusBadge(status: order.orderStatus),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Order ID: #${order.id} • Placed on: ${Formatters.dateTime(order.createdAt)}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    const SizedBox(height: 16),

                    const Text('Items Purchased', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warmDarkBrown)),
                    const SizedBox(height: 8),
                    ...order.items.map((item) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.warmBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AppImage(
                                  url: item.product.images.isNotEmpty ? item.product.images.first : '',
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text('Qty: ${item.quantity} x ${Formatters.currency(item.unitPrice)}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              Text(Formatters.currency(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.success)),
                            ],
                          ),
                        )),
                    const Divider(height: 20),

                    const Text('Delivery & Payment Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warmDarkBrown)),
                    const SizedBox(height: 6),
                    Text('Delivery Address: ${order.deliveryAddress}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    Text('Payment Method: ${order.paymentMethod}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount Paid', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
                        Text(Formatters.currency(order.totalAmount), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.success)),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close Receipt Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
