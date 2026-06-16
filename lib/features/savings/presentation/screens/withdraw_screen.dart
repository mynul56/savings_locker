import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../bloc/savings_bloc.dart';
import '../../domain/entities/deposit_entity.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  late SavingsBloc _savingsBloc;

  @override
  void initState() {
    super.initState();
    _savingsBloc = context.read<SavingsBloc>();
    
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated) {
      _savingsBloc.add(LoadDeposits(authState.user.uid));
    }
  }

  @override
  void dispose() {
    // Don't close the globally provided SavingsBloc
    super.dispose();
  }

  void _handleWithdraw(BuildContext context, DepositEntity deposit) {
    if (!deposit.canWithdraw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This deposit is still locked.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Withdrawal'),
        content: Text('Are you sure you want to withdraw \$${deposit.amount.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final authState = context.read<AuthenticationBloc>().state;
              if (authState is AuthenticationAuthenticated) {
                _savingsBloc.add(
                  WithdrawDeposit(
                    uid: authState.user.uid,
                    depositId: deposit.depositId,
                  ),
                );
              }
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Savings'),
        centerTitle: true,
      ),
      body: BlocConsumer<SavingsBloc, SavingsState>(
        bloc: _savingsBloc,
        listener: (context, state) {
          if (state is SavingsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SavingsLoading || state is SavingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SavingsLoaded) {
            final activeDeposits = state.deposits.where((d) => d.status == 'active').toList();

            if (activeDeposits.isEmpty) {
              return const Center(
                child: Text('No active deposits available for withdrawal.'),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: activeDeposits.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final deposit = activeDeposits[index];
                
                return Card(
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
                                Icon(
                                  deposit.isLocked ? LucideIcons.lock : LucideIcons.wallet,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  deposit.isLocked ? 'Locked Savings' : 'Flexible Savings',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Text(
                              '\$${deposit.amount.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (deposit.isLocked && deposit.lockUntil != null) ...[
                          Text(
                            'Unlocks: ${DateFormat.yMMMd().format(deposit.lockUntil!)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: deposit.canWithdraw ? colorScheme.secondary : colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: deposit.canWithdraw
                                ? () => _handleWithdraw(context, deposit)
                                : null,
                            icon: const Icon(LucideIcons.arrowUpFromLine, size: 18),
                            label: const Text('Withdraw Funds'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              side: BorderSide(
                                color: deposit.canWithdraw 
                                    ? colorScheme.primary 
                                    : colorScheme.outline.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
