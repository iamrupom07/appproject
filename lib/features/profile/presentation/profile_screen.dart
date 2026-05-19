import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/presentation/providers/user_provider.dart';

/// Profile screen — lets the user update their display name and password.
/// Guest users see a prompt to log in instead of the edit fields.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSavingName = false;
  bool _isSavingPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ref.read(userProvider);
    if (_nameController.text.isEmpty) {
      _nameController.text = user.name;
    }
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showSnack('Name cannot be empty', isError: true);
      return;
    }
    setState(() => _isSavingName = true);
    await ref.read(userProvider.notifier).updateName(name);
    if (!mounted) return;
    setState(() => _isSavingName = false);
    _showSnack('Name updated successfully');
  }

  Future<void> _savePassword() async {
    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;
    final storedPassword = ref.read(userProvider).password;

    if (current != storedPassword) {
      _showSnack('Current password is incorrect', isError: true);
      return;
    }
    if (newPass.length < 6) {
      _showSnack('New password must be at least 6 characters', isError: true);
      return;
    }
    if (newPass != confirm) {
      _showSnack('Passwords do not match', isError: true);
      return;
    }

    setState(() => _isSavingPassword = true);
    await ref.read(userProvider.notifier).updatePassword(newPass);
    if (!mounted) return;
    setState(() => _isSavingPassword = false);
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    _showSnack('Password updated successfully');
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.outOfStock : AppColors.inStock,
      ),
    );
  }

  void _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        title: const Text('Sign out?'),
        content: const Text('You will be returned to the login screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.outOfStock),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(userProvider.notifier).logout();
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          child: user.isGuest
              ? _GuestPrompt(onLogin: () => context.go('/login'))
              : _ProfileBody(
            user: user,
            nameController: _nameController,
            currentPasswordController: _currentPasswordController,
            newPasswordController: _newPasswordController,
            confirmPasswordController: _confirmPasswordController,
            obscureCurrent: _obscureCurrent,
            obscureNew: _obscureNew,
            obscureConfirm: _obscureConfirm,
            isSavingName: _isSavingName,
            isSavingPassword: _isSavingPassword,
            onToggleCurrent: () =>
                setState(() => _obscureCurrent = !_obscureCurrent),
            onToggleNew: () =>
                setState(() => _obscureNew = !_obscureNew),
            onToggleConfirm: () =>
                setState(() => _obscureConfirm = !_obscureConfirm),
            onSaveName: _saveName,
            onSavePassword: _savePassword,
            onLogout: _logout,
          ),
        ),
      ),
    );
  }
}

// ─── Guest Prompt ─────────────────────────────────────────────────────────────

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt({required this.onLogin});
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 40,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: AppSizes.spaceLg),
            Text('You\'re browsing as Guest',
                style: AppTextStyles.headingLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.spaceSm),
            Text(
              'Sign in to manage your profile, change your name and password.',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceLg),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  elevation: 0,
                ),
                child: Text('Sign In',
                    style: AppTextStyles.headingSmall
                        .copyWith(color: Colors.white, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Body ─────────────────────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.user,
    required this.nameController,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscureCurrent,
    required this.obscureNew,
    required this.obscureConfirm,
    required this.isSavingName,
    required this.isSavingPassword,
    required this.onToggleCurrent,
    required this.onToggleNew,
    required this.onToggleConfirm,
    required this.onSaveName,
    required this.onSavePassword,
    required this.onLogout,
  });

  final dynamic user;
  final TextEditingController nameController;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool obscureCurrent;
  final bool obscureNew;
  final bool obscureConfirm;
  final bool isSavingName;
  final bool isSavingPassword;
  final VoidCallback onToggleCurrent;
  final VoidCallback onToggleNew;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSaveName;
  final VoidCallback onSavePassword;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Header ──────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceMd, AppSizes.spaceMd, AppSizes.spaceMd, 0),
            child: Row(
              children: [
                Text('Profile', style: AppTextStyles.displayMedium),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),

        // ── Avatar + email ───────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (user.name.isNotEmpty ? user.name[0] : 'U')
                          .toUpperCase(),
                      style: AppTextStyles.displayLarge
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceSm),
                Text(user.email,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),

        // ── Change Name Card ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _SectionCard(
            title: 'Display Name',
            icon: Icons.person_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileField(
                  controller: nameController,
                  label: 'Full name',
                  hint: 'Enter your name',
                  prefixIcon: Icons.badge_outlined,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSizes.spaceMd),
                _SaveButton(
                  label: 'Save Name',
                  isLoading: isSavingName,
                  onTap: onSaveName,
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMd)),

        // ── Change Password Card ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _SectionCard(
            title: 'Change Password',
            icon: Icons.lock_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileField(
                  controller: currentPasswordController,
                  label: 'Current password',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: obscureCurrent,
                  suffixIcon: GestureDetector(
                    onTap: onToggleCurrent,
                    child: Icon(
                      obscureCurrent
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceMd),
                _ProfileField(
                  controller: newPasswordController,
                  label: 'New password',
                  hint: 'Min. 6 characters',
                  prefixIcon: Icons.lock_reset_rounded,
                  obscureText: obscureNew,
                  suffixIcon: GestureDetector(
                    onTap: onToggleNew,
                    child: Icon(
                      obscureNew
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceMd),
                _ProfileField(
                  controller: confirmPasswordController,
                  label: 'Confirm new password',
                  hint: 'Re-enter new password',
                  prefixIcon: Icons.check_circle_outline_rounded,
                  obscureText: obscureConfirm,
                  textInputAction: TextInputAction.done,
                  suffixIcon: GestureDetector(
                    onTap: onToggleConfirm,
                    child: Icon(
                      obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceMd),
                _SaveButton(
                  label: 'Update Password',
                  isLoading: isSavingPassword,
                  onTap: onSavePassword,
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMd)),

        // ── Sign Out ─────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
            child: GestureDetector(
              onTap: onLogout,
              child: Container(
                height: AppSizes.buttonHeight,
                decoration: BoxDecoration(
                  color: AppColors.outOfStock.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                      color: AppColors.outOfStock.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded,
                        color: AppColors.outOfStock, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.outOfStock,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: AppSizes.spaceLg +
                AppSizes.navBarHeight +
                MediaQuery.of(context).padding.bottom,
          ),
        ),
      ],
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.gold),
                const SizedBox(width: 8),
                Text(title,
                    style: AppTextStyles.headingMedium
                        .copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: AppSizes.spaceMd),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: AppSizes.spaceMd),
            child,
          ],
        ),
      ),
    );
  }
}

// ─── Profile Field ────────────────────────────────────────────────────────────

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            )),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          textInputAction: textInputAction,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary.withValues(alpha: 0.7)),
            prefixIcon:
            Icon(prefixIcon, size: 20, color: AppColors.textSecondary),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              borderSide:
              const BorderSide(color: AppColors.divider, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              borderSide:
              const BorderSide(color: AppColors.gold, width: 1.5),
            ),
            filled: true,
            fillColor: AppColors.pageBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Save Button ──────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : Text(
            label,
            style: AppTextStyles.headingSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}