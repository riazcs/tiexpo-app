import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tiexpo/services/user_profile_service.dart';
import 'package:tiexpo/theme.dart';

class DashboardProfileScreen extends StatefulWidget {
  const DashboardProfileScreen({super.key, this.onSignOut});

  final ValueChanged<BuildContext>? onSignOut;

  @override
  State<DashboardProfileScreen> createState() => _DashboardProfileScreenState();
}

class _DashboardProfileScreenState extends State<DashboardProfileScreen> {
  // ---- Brand tokens -------------------------------------------------------
  static const Color brandPurple = Color(0xFF7E22CE);
  static const Color brandFuchsia = Color(0xFFC026D3);
  static const Color accentMauve = Color(0xFFA083B3);
  static const Color ink = Color(0xFF1E1B2E);
  static const Color line = Color(0xFFE8E4EE);
  static const Color softLine = Color(0xFFF1EFF5);
  static const Color pageTint = Color(0xFFF7F5FB);

  Map<String, dynamic> userData = {};
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // =========================================================================
  // DATA
  // =========================================================================

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedUser = prefs.getString('auth_user_data');
    if (encodedUser != null) {
      try {
        final decodedUser = jsonDecode(encodedUser);
        if (decodedUser is Map) {
          if (mounted) {
            setState(() {
              userData = Map<String, dynamic>.from(decodedUser);
              _isLoading = false;
            });
          }
        }
      } on FormatException {
        await prefs.remove('auth_user_data');
      }
    }

    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final freshUser = await UserProfileService.load(token: token);
      await prefs.setString('auth_user_data', jsonEncode(freshUser));
      final userId = freshUser['id']?.toString();
      if (userId != null && userId.isNotEmpty) {
        await prefs.setString('auth_user_id', userId);
      }
      if (mounted) setState(() => userData = freshUser);
    } catch (_) {
      if (mounted && userData.isEmpty) {
        setState(() {
          _loadError = 'Could not load your profile. Please sign in again.';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _retry() {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    _loadUserData();
  }

  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user_id');
    await prefs.remove('auth_user_data');
    if (!mounted) return;
    if (widget.onSignOut != null) {
      widget.onSignOut!(context);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _copy(String value, String label) async {
    if (value.isEmpty || value == 'Not provided') return;
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: ink,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // =========================================================================
  // FORMATTERS
  // =========================================================================

  String _value(String key, {String fallback = 'Not provided'}) {
    final value = userData[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    if (value is num) return value.toString();
    return fallback;
  }

  String _firstValue(List<String> keys, {String fallback = 'Not provided'}) {
    for (final key in keys) {
      final value = _value(key, fallback: '');
      if (value.isNotEmpty) return value;
    }
    return fallback;
  }

  String _roleLabel() {
    final type = _value('type', fallback: '');
    if (type.isNotEmpty) return _titleCase(type);
    final roles = userData['roles'];
    if (roles is List) {
      final names = roles
          .whereType<Map>()
          .map((role) => role['name'])
          .whereType<String>()
          .toList();
      if (names.isNotEmpty) return names.map(_titleCase).join(', ');
    }
    return 'Not provided';
  }

  String _titleCase(String value) => value
      .split(RegExp(r'[_\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');

  String _registrationDate() {
    final rawDate = _value('created_at', fallback: '');
    if (rawDate.isEmpty) return 'Not provided';
    final date = DateTime.tryParse(rawDate);
    if (date == null) return rawDate;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // =========================================================================
  // BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    final name = _value('name', fallback: 'User');
    final profilePicture = _value('profile_picture', fallback: '');
    final profilePictureUri = Uri.tryParse(profilePicture);
    final profileImage =
        profilePictureUri != null && profilePictureUri.hasScheme
            ? NetworkImage(profilePictureUri.toString())
            : null;
    final company = _firstValue([
      'company_name',
      'organization',
      'company_profile',
    ]);
    final role = _roleLabel();
    final initials = name.trim().isEmpty
        ? 'U'
        : name
            .trim()
            .split(RegExp(r'\s+'))
            .take(2)
            .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
            .join();

    return Scaffold(
      backgroundColor: pageTint,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: ink,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: ink),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: _signOut,
              tooltip: 'Sign Out',
              icon: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 18,
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: softLine),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
        child: _buildBody(
          name: name,
          initials: initials,
          profileImage: profileImage,
          role: role,
          company: company,
        ),
      ),
    );
  }

  Widget _buildBody({
    required String name,
    required String initials,
    required ImageProvider? profileImage,
    required String role,
    required String company,
  }) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(
                color: brandPurple,
                strokeWidth: 2.6,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading your profile…',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: brandPurple.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  color: brandPurple.withOpacity(0.7),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _loadError!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try Again'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: brandPurple,
                  side: const BorderSide(color: brandPurple, width: 1.4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _heroCard(
                name: name,
                initials: initials,
                profileImage: profileImage,
                role: role,
              ),
              const SizedBox(height: 16),
              _accessBadgeCard(),
              const SizedBox(height: 26),
              _sectionHeader('Account Information'),
              const SizedBox(height: 12),
              _infoCard(company: company),
              const SizedBox(height: 26),
              _actions(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // HERO CARD
  // =========================================================================

  Widget _heroCard({
    required String name,
    required String initials,
    required ImageProvider? profileImage,
    required String role,
  }) {
    final jobTitle = _value('job_title', fallback: '');
    final status = _value('status', fallback: 'Active');

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B1A8B), Color(0xFF7E22CE), Color(0xFFC026D3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: brandPurple.withOpacity(0.30),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative bubbles
          Positioned(
            top: -55,
            right: -35,
            child: _bubble(150, 0.10),
          ),
          Positioned(
            bottom: -70,
            left: -45,
            child: _bubble(170, 0.07),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                          width: 1.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 33,
                        backgroundColor: Colors.white,
                        backgroundImage: profileImage,
                        child: profileImage == null
                            ? Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: brandPurple,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.15,
                            ),
                          ),
                          if (jobTitle.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              jobTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.78),
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.28),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  size: 12,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    role,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.16),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _miniStat('Member Since', _registrationDate()),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white.withOpacity(0.18),
                    ),
                    _miniStat('Status', _titleCase(status)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.65),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // DIGITAL ACCESS BADGE
  // =========================================================================

  Widget _accessBadgeCard() {
    final status = _value('status', fallback: 'Active');
    final accountId = _value('id');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: line),
        boxShadow: [
          BoxShadow(
            color: accentMauve.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconTile(Icons.qr_code_2_rounded, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Digital Access Badge',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Scan at the entrance',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              _statusPill(status),
            ],
          ),
          const SizedBox(height: 18),
          _dashedDivider(),
          const SizedBox(height: 16),
          _badgeRow(
            'Account ID',
            accountId,
            onCopy: accountId == 'Not provided'
                ? null
                : () => _copy(accountId, 'Account ID'),
          ),
          const SizedBox(height: 12),
          _badgeRow('Event Access', _value('event')),
        ],
      ),
    );
  }

  Widget _statusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _titleCase(status),
            style: const TextStyle(
              color: Color(0xFF047857),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeRow(String label, String value, {VoidCallback? onCopy}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: ink,
            ),
          ),
        ),
        if (onCopy != null) ...[
          const SizedBox(width: 8),
          InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(
                Icons.copy_rounded,
                size: 15,
                color: brandPurple.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _dashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 5.0;
        const dashSpace = 4.0;
        final count =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor().clamp(1, 200);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1.2,
              color: line,
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // ACCOUNT INFO
  // =========================================================================

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 17,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [brandPurple, brandFuchsia],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
      ],
    );
  }

  Widget _infoCard({required String company}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: line),
        boxShadow: [
          BoxShadow(
            color: accentMauve.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.email_outlined,
            'Email Address',
            _value('email'),
          ),
          _divider(),
          _buildInfoRow(
            Icons.phone_outlined,
            'Phone Number',
            _value('phone'),
          ),
          _divider(),
          _buildInfoRow(
            Icons.business_outlined,
            'Company / Organization',
            company,
          ),
          _divider(),
          _buildInfoRow(
            Icons.calendar_today_outlined,
            'Registration Date',
            _registrationDate(),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1, color: softLine);

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              _iconTile(icon, size: 40),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ink,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) _divider(),
      ],
    );
  }

  Widget _iconTile(IconData icon, {double size = 42}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            brandPurple.withOpacity(0.12),
            brandFuchsia.withOpacity(0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: brandPurple, size: size * 0.48),
    );
  }

  // =========================================================================
  // ACTIONS
  // =========================================================================

  Widget _actions() {
    return Row(
      children: [
        Expanded(
          child: _primaryButton(
            icon: Icons.edit_outlined,
            label: 'Edit Profile',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _secondaryButton(
            icon: Icons.download_rounded,
            label: 'Download Badge',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _primaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7E22CE), Color(0xFFC026D3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: brandPurple.withOpacity(0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brandPurple.withOpacity(0.35), width: 1.4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: brandPurple, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: brandPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}