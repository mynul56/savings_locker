import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../bloc/savings_bloc.dart';

class UpcomingMaturitiesScreen extends StatelessWidget {
  const UpcomingMaturitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Maturities'),
      ),
      body: BlocBuilder<SavingsBloc, SavingsState>(
        builder: (context, state) {
          if (state is SavingsLoaded) {
            final lockedDeposits = state.deposits
                .where((d) => d.status == 'active' && d.isLocked && d.lockUntil != null)
                .toList()
              ..sort((a, b) => a.lockUntil!.compareTo(b.lockUntil!));

            if (lockedDeposits.isEmpty) {
              return const Center(child: Text('No upcoming maturities'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lockedDeposits.length,
              itemBuilder: (context, index) {
                final deposit = lockedDeposits[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
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
                    subtitle: Text('Unlocks on ${DateFormat.yMMMd().format(deposit.lockUntil!)}'),
                    trailing: Text(
                      NumberFormat.currency(symbol: '\$').format(deposit.amount),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
