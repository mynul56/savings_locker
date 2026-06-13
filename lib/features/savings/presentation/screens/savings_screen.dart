import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../bloc/savings_bloc.dart';
import '../../domain/entities/deposit_entity.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Savings'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () {
              context.push('/create-deposit');
            },
          ),
        ],
      ),
      body: BlocBuilder<SavingsBloc, SavingsState>(
        builder: (context, state) {
          if (state is SavingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavingsFailure) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: colorScheme.error),
              ),
            );
          } else if (state is SavingsLoaded) {
            if (state.deposits.isEmpty) {
              return Center(
                child: Text(
                  'No deposits yet. Start saving!',
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.deposits.length,
              itemBuilder: (context, index) {
                final deposit = state.deposits[index];
                return _buildDepositCard(context, deposit);
              },
            );
          }
          return const Center(child: Text('Initialize Savings'));
        },
      ),
    );
  }

  Widget _buildDepositCard(BuildContext context, DepositEntity deposit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLocked = deposit.isLocked;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isLocked
                            ? colorScheme.primary.withValues(alpha: 0.1)
                            : colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isLocked ? LucideIcons.lock : LucideIcons.wallet,
                        color: isLocked
                            ? colorScheme.primary
                            : colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isLocked ? 'Locked Savings' : 'Flexible Savings',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  NumberFormat.currency(symbol: '\$').format(deposit.amount),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLocked && deposit.lockUntil != null)
              Row(
                children: [
                  Icon(
                    LucideIcons.calendarClock,
                    size: 16,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Unlocks on ${DateFormat.yMMMd().format(deposit.lockUntil!)}',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: deposit.status == 'active'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    deposit.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: deposit.status == 'active'
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                ),
                if (deposit.status == 'active')
                  TextButton(
                    onPressed: deposit.canWithdraw
                        ? () {
                            final uid =
                                context.read<AuthenticationBloc>().state
                                    is AuthenticationAuthenticated
                                ? (context.read<AuthenticationBloc>().state
                                          as AuthenticationAuthenticated)
                                      .user
                                      .uid
                                : null;
                            if (uid != null) {
                              context.read<SavingsBloc>().add(
                                WithdrawDeposit(
                                  uid: uid,
                                  depositId: deposit.depositId,
                                ),
                              );
                            }
                          }
                        : null,
                    child: const Text('Withdraw'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
