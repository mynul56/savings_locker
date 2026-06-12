import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../authentication/presentation/bloc/authentication_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationUnauthenticated) {
          context.go('/login');
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(LucideIcons.user, size: 50, color: colorScheme.primary),
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    return Column(
                      children: [
                        Text(
                          state.user.fullName,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.user.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(context, 'Settings'),
              _buildListTile(context, 'Account Settings', LucideIcons.settings),
              _buildListTile(context, 'Notifications', LucideIcons.bell),
              _buildListTile(context, 'Security', LucideIcons.shield),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'About'),
              _buildListTile(context, 'Privacy Policy', LucideIcons.fileText),
              _buildListTile(context, 'Terms of Service', LucideIcons.file),
              const SizedBox(height: 32),
              ListTile(
                leading: Icon(LucideIcons.logOut, color: colorScheme.error),
                title: Text('Log Out', style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.w600)),
                onTap: () {
                  context.read<AuthenticationBloc>().add(LogoutRequested());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(LucideIcons.chevronRight, size: 20),
      contentPadding: EdgeInsets.zero,
      onTap: () {},
    );
  }
}
