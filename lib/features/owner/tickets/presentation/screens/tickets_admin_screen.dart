import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../../../../customer/tickets/data/models/ticket.dart';
import '../bloc/tickets_admin_cubit.dart';

class TicketsAdminScreen extends StatelessWidget {
  const TicketsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TicketsAdminCubit()..start(),
      child: SecureScaffold(
        appBar: AppBar(
          title: const Text('Maintenance Tickets'),
          actions: const [LanguageButton()],
        ),
        body: BlocBuilder<TicketsAdminCubit, TicketsAdminState>(
          builder: (context, state) {
            if (state.status == TicketsAdminStatus.loading &&
                state.tickets.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.tickets.isEmpty) {
              return const Center(
                child: Text('No tickets yet.'),
              );
            }

            return ListView.separated(
              itemCount: state.tickets.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final ticket = state.tickets[index];
                return ListTile(
                  title: Text(ticket.issueType),
                  subtitle: Text(
                    'Urgency: ${ticket.urgency} · Status: ${ticket.status}',
                  ),
                  onTap: () => _showTicketBottomSheet(context, ticket),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showTicketBottomSheet(BuildContext context, Ticket ticket) {
    final statusOptions = ['open', 'in_progress', 'closed'];
    final priorityOptions = ['low', 'normal', 'high'];

    String status = ticket.status;
    String priority = ticket.urgency;

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Ticket',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: status,
                items: statusOptions
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    status = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              DropdownButtonFormField<String>(
                initialValue: priority,
                items: priorityOptions
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(p),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    priority = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<TicketsAdminCubit>().updateStatus(
                          id: ticket.id,
                          status: status,
                          priority: priority,
                        );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

