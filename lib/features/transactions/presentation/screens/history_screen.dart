import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../injection_container/injection.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../bloc/transactions_bloc.dart';
import '../bloc/transactions_event.dart';
import '../bloc/transactions_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late TransactionsBloc _transactionsBloc;

  @override
  void initState() {
    super.initState();
    _transactionsBloc = sl<TransactionsBloc>();
    
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated) {
      _transactionsBloc.add(LoadTransactions(authState.user.uid));
    }
  }

  @override
  void dispose() {
    _transactionsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        bloc: _transactionsBloc,
        builder: (context, state) {
          if (state is TransactionsLoading || state is TransactionsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionsError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          if (state is TransactionsLoaded) {
            final transactions = state.transactions;

            if (transactions.isEmpty) {
              return const Center(
                child: Text('No transactions yet.'),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final isDeposit = tx.type == 'deposit';
                
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDeposit 
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : colorScheme.secondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDeposit ? LucideIcons.arrowDownToLine : LucideIcons.arrowUpFromLine,
                      color: isDeposit ? colorScheme.primary : colorScheme.secondary,
                    ),
                  ),
                  title: Text(
                    tx.description,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().add_jm().format(tx.createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: Text(
                    '${isDeposit ? "+" : "-"}\$${tx.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDeposit ? colorScheme.primary : colorScheme.onSurface,
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
