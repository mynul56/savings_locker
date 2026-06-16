import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../../savings/presentation/bloc/savings_bloc.dart';
import '../../../savings/domain/entities/deposit_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated) {
      context.read<SavingsBloc>().add(LoadDeposits(authState.user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<SavingsBloc, SavingsState>(
      builder: (context, state) {
        double totalBalance = 0;
        double flexibleBalance = 0;
        double lockedBalance = 0;
        DepositEntity? upcomingMaturity;

        if (state is SavingsLoaded) {
          final activeDeposits = state.deposits.where((d) => d.status == 'active');
          for (var deposit in activeDeposits) {
            totalBalance += deposit.amount;
            if (deposit.isLocked) {
              lockedBalance += deposit.amount;
              // Find the nearest upcoming maturity
              if (deposit.lockUntil != null) {
                if (upcomingMaturity == null || deposit.lockUntil!.isBefore(upcomingMaturity.lockUntil!)) {
                  upcomingMaturity = deposit;
                }
              }
            } else {
              flexibleBalance += deposit.amount;
            }
          }
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormat.currency(symbol: '\$').format(totalBalance),
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                      child: IconButton(
                        icon: Icon(LucideIcons.bell, color: colorScheme.primary),
                        onPressed: () => context.push('/notifications'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildBalanceCard(
                        context: context,
                        title: 'Flexible',
                        amount: NumberFormat.currency(symbol: '\$').format(flexibleBalance),
                        icon: LucideIcons.wallet,
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildBalanceCard(
                        context: context,
                        title: 'Locked',
                        amount: NumberFormat.currency(symbol: '\$').format(lockedBalance),
                        icon: LucideIcons.lock,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
            Text('Quick Actions', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  context,
                  'Deposit',
                  LucideIcons.arrowDownToLine,
                  () => context.push('/create-deposit'),
                ),
                _buildActionButton(
                  context,
                  'Withdraw',
                  LucideIcons.arrowUpFromLine,
                  () => context.push('/withdraw'),
                ),
                _buildActionButton(
                  context, 
                  'New Goal', 
                  LucideIcons.target,
                  () => context.push('/create-goal'),
                ),
                _buildActionButton(
                  context, 
                  'History', 
                  LucideIcons.history,
                  () => context.push('/history'),
                ),
              ],
            ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upcoming Maturities', style: theme.textTheme.titleLarge),
                    TextButton(onPressed: () {}, child: const Text('See All')),
                  ],
                ),
                const SizedBox(height: 16),
                if (upcomingMaturity != null)
                  Card(
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          LucideIcons.calendarClock,
                          color: colorScheme.primary,
                        ),
                      ),
                      title: const Text(
                        'Locked Deposit',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('Unlocks on ${DateFormat.yMMMd().format(upcomingMaturity.lockUntil!)}'),
                      trailing: Text(
                        NumberFormat.currency(symbol: '\$').format(upcomingMaturity.amount),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('No upcoming maturities')),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard({
    required BuildContext context,
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
