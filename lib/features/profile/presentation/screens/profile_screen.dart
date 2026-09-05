import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/constants.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _locationAccess = true;
  String _selectedLanguage = 'English (English)';

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authProvider);
    final user = userAsync.value;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.warmBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.warmDarkBrown, size: 26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'My Krushi Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.warmDarkBrown,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.warmDarkBrown, size: 24),
            tooltip: 'App Settings',
            onPressed: () => _showSettingsBottomSheet(context, user),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. User Profile Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warmBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: const Color(0xFFFAF7F2),
                          backgroundImage: NetworkImage(
                            user?.profilePhoto ??
                                'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primaryGreen,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Camera profile upload triggered')),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user?.name ?? 'bharath poojary',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.warmDarkBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.phone ?? '+91 9876543210',
                      style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${user?.address ?? 'Green Farm House, Thirthahalli Road, Shivamogga'}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Role Chip & Role Switcher Dropdown
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF5E6C4), width: 1),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Active Platform Role:',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          DropdownButton<String>(
                            value: user?.role ?? AppConstants.roleFarmer,
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.warmDarkBrown,
                            ),
                            items: AppConstants.allRoles.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Center(
                                  child: Text(
                                    role,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newRole) {
                              if (newRole != null) {
                                ref.read(authProvider.notifier).switchRole(newRole);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Role switched to $newRole!'),
                                    backgroundColor: AppColors.primaryGreen,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Options List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warmBorder, width: 1),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.stars_rounded, color: AppColors.primaryGreen),
                    title: const Text('Join as Worker / Machine Owner', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                    subtitle: const Text('Submit application to rent machines or work as operator'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/provider/join'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.assignment_outlined, color: AppColors.warmDarkBrown),
                    title: const Text('My Applications & Approval Status', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
                    subtitle: const Text('Track pending, approved or rejected applications'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/provider/my-applications'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined, color: AppColors.warmDarkBrown),
                    title: const Text('App Preferences & Settings', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
                    subtitle: const Text('Language, notifications, location & support'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showSettingsBottomSheet(context, user),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.agriculture_rounded, color: AppColors.primaryGreen),
                    title: const Text('List My Machine for Rent'),
                    subtitle: const Text('Earn income by renting your tractor or harvester'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/machinery/add'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.storefront_rounded, color: AppColors.primaryGreen),
                    title: const Text('Post Produce for Sale'),
                    subtitle: const Text('Sell arecanut, pepper, coffee directly to buyers'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/marketplace/create'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.engineering_rounded, color: AppColors.primaryGreen),
                    title: const Text('Register as Farm Worker / Operator'),
                    subtitle: const Text('Find daily agricultural field work'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/workers/register'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryGreen),
                    title: const Text('Admin Dashboard Portal'),
                    subtitle: const Text('Manage platform verification & users'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/admin'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Log Out',
              isOutlined: true,
              backgroundColor: AppColors.error,
              textColor: AppColors.error,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out of Krushi Mithra')),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Settings Bottom Sheet Implementation
  void _showSettingsBottomSheet(BuildContext context, User? user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.82,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF3E0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.settings_rounded, color: AppColors.warmDarkBrown, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Krushi Mithra Settings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warmDarkBrown,
                            ),
                          ),
                          Text(
                            'Configure preferences & platform options',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView(
                      children: [
                        // Section 1: Language Settings
                        const Text(
                          'Language / ಭಾಷೆ',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF7F2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.warmBorder),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.language_rounded, color: AppColors.primaryGreen),
                            title: Text(_selectedLanguage, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                            onTap: () {
                              _showLanguagePicker(context, (lang) {
                                setState(() => _selectedLanguage = lang);
                                setModalState(() => _selectedLanguage = lang);
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Section 2: Notifications Switch
                        const Text(
                          'Push Notifications',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF7F2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.warmBorder),
                          ),
                          child: SwitchListTile(
                            secondary: const Icon(Icons.notifications_active_rounded, color: AppColors.primaryGreen),
                            title: const Text('Rental & Booking Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('Receive instant SMS & app notifications', style: TextStyle(fontSize: 11)),
                            activeColor: AppColors.primaryGreen,
                            value: _notificationsEnabled,
                            onChanged: (val) {
                              setState(() => _notificationsEnabled = val);
                              setModalState(() => _notificationsEnabled = val);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Section 3: GPS & Location
                        const Text(
                          'Location Services',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF7F2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.warmBorder),
                          ),
                          child: SwitchListTile(
                            secondary: const Icon(Icons.location_on_rounded, color: AppColors.primaryGreen),
                            title: const Text('Automatic GPS Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text('Current: ${user?.locationName ?? 'Shivamogga, KA'}', style: const TextStyle(fontSize: 11)),
                            activeColor: AppColors.primaryGreen,
                            value: _locationAccess,
                            onChanged: (val) {
                              setState(() => _locationAccess = val);
                              setModalState(() => _locationAccess = val);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Section 4: Help & Helpline Support
                        const Text(
                          'Help & Customer Support',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF7F2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.warmBorder),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.headset_mic_rounded, color: AppColors.primaryGreen),
                                title: const Text('Call Toll-Free Helpline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                subtitle: const Text('1800-425-9999 (24/7 Farmer Support)', style: TextStyle(fontSize: 11)),
                                onTap: () async {
                                  final launched = await UrlLauncherHelper.makePhoneCall('18004259999');
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(launched
                                            ? 'Dialing Toll-Free Helpline: 1800-425-9999'
                                            : 'Connecting to Helpline: 1800-425-9999 (24/7 Farmer Support)'),
                                        backgroundColor: AppColors.primaryGreen,
                                        duration: const Duration(seconds: 4),
                                      ),
                                    );
                                  }
                                },
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.whatsappGreen),
                                title: const Text('WhatsApp Support', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                subtitle: const Text('Get instant help on WhatsApp', style: TextStyle(fontSize: 11)),
                                onTap: () async {
                                  final launched = await UrlLauncherHelper.openWhatsApp(
                                    phoneNumber: '+919876543210',
                                    message: 'Namaste Krushi Mithra Team, I need assistance with my farming services.',
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(launched
                                            ? 'Opening WhatsApp Support Chat...'
                                            : 'Connecting to WhatsApp Support (+91 9876543210)...'),
                                        backgroundColor: AppColors.whatsappGreen,
                                        duration: const Duration(seconds: 4),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // App Version Badge
                        const Center(
                          child: Text(
                            'Krushi Mithra v1.0.0 • Made for Farmers',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguagePicker(BuildContext context, Function(String) onSelect) {
    final languages = [
      'English (English)',
      'ಕನ್ನಡ (Kannada)',
      'हिंदी (Hindi)',
      'తెలుగు (Telugu)',
      'தமிழ் (Tamil)',
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Select App Language', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              return ListTile(
                title: Text(lang, style: const TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  onSelect(lang);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Language set to $lang')),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
