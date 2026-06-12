import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../bloc/savings_bloc.dart';

class CreateDepositScreen extends StatefulWidget {
  const CreateDepositScreen({super.key});

  @override
  State<CreateDepositScreen> createState() => _CreateDepositScreenState();
}

class _CreateDepositScreenState extends State<CreateDepositScreen> {
  final _amountController = TextEditingController();
  bool _isLocked = false;
  DateTime? _lockUntil;

  void _onCreate() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (_isLocked && _lockUntil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a maturity date for locked savings')),
      );
      return;
    }

    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated) {
      context.read<SavingsBloc>().add(
            CreateDeposit(
              uid: authState.user.uid,
              amount: amount,
              isLocked: _isLocked,
              lockUntil: _isLocked ? _lockUntil : null,
            ),
          );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add to Savings')),
      body: BlocListener<SavingsBloc, SavingsState>(
        listener: (context, state) {
          if (state is SavingsLoaded) {
            context.pop(); // Go back on success
          } else if (state is SavingsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Lock Savings?'),
                subtitle: const Text('Locked savings cannot be withdrawn until maturity.'),
                value: _isLocked,
                onChanged: (val) {
                  setState(() {
                    _isLocked = val;
                    if (!val) _lockUntil = null;
                  });
                },
              ),
              if (_isLocked) ...[
                const SizedBox(height: 16),
                ListTile(
                  title: Text(_lockUntil == null
                      ? 'Select Maturity Date'
                      : 'Unlocks on: ${_lockUntil!.toLocal().toString().split(' ')[0]}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 30)),
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                    );
                    if (date != null) {
                      setState(() {
                        _lockUntil = date;
                      });
                    }
                  },
                ),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: _onCreate,
                child: const Text('Deposit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
