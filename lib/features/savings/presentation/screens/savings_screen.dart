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
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.piggyBank,
                          size: 80,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Start Your Savings Journey',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create your first deposit to start securing your financial future.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/create-deposit'),
                        icon: const Icon(LucideIcons.plus),
                        label: const Text('Create Deposit'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                      ),
                    ],
                  ),
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
    final isLocked = deposit.isLocked;

    // Define premium gradients
    final lockedGradient = const LinearGradient(
      colors: [Color(0xFF6B4EFF), Color(0xFF4A3AFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    
    final flexibleGradient = const LinearGradient(
      colors: [Color(0xFF00C48C), Color(0xFF00A376)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: isLocked ? lockedGradient : flexibleGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isLocked ? const Color(0xFF6B4EFF) : const Color(0xFF00C48C))
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isLocked ? LucideIcons.lock : LucideIcons.wallet,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      isLocked ? 'Locked Savings' : 'Flexible Savings',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  NumberFormat.currency(symbol: '\$').format(deposit.amount),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isLocked && deposit.lockUntil != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.calendarClock, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Unlocks on ${DateFormat.yMMMd().format(deposit.lockUntil!)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            if (isLocked && deposit.lockUntil != null)
              const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    deposit.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? const Color(0xFF6B4EFF) : const Color(0xFF00C48C),
                    ),
                  ),
                ),
                if (deposit.status == 'active')
                  ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: isLocked ? const Color(0xFF6B4EFF) : const Color(0xFF00C48C),
                      disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
                      disabledForegroundColor: Colors.black38,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
