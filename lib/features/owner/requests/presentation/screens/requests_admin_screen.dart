import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../../../../customer/services/data/models/service_request.dart';
import '../bloc/requests_admin_cubit.dart';

class RequestsAdminScreen extends StatelessWidget {
  const RequestsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequestsAdminCubit()..start(),
      child: SecureScaffold(
        appBar: AppBar(
          title: const Text('Service Requests'),
          actions: const [LanguageButton()],
        ),
        body: BlocBuilder<RequestsAdminCubit, RequestsAdminState>(
          builder: (context, state) {
            if (state.status == RequestsAdminStatus.loading &&
                state.requests.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.requests.isEmpty) {
              return const Center(
                child: Text('No service requests yet.'),
              );
            }

            return ListView.separated(
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final req = state.requests[index];
                return ListTile(
                  title: Text('${req.name} – ${req.township}'),
                  subtitle: Text(
                    'Status: ${req.status} · Cameras: ${req.cameraCount}',
                  ),
                  onTap: () => _showRequestBottomSheet(context, req),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showRequestBottomSheet(BuildContext context, ServiceRequest req) {
    final statusOptions = [
      'pending',
      'scheduled',
      'installing',
      'completed',
    ];
    final notesCtrl = TextEditingController();
    final scheduleCtrl = TextEditingController();
    String status = req.status;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Request',
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
              TextField(
                controller: scheduleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Scheduled date/time (optional)',
                ),
              ),
              TextField(
                controller: notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Admin notes (optional)',
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<RequestsAdminCubit>().updateStatus(
                          id: req.id,
                          status: status,
                          notes: notesCtrl.text.trim().isEmpty
                              ? null
                              : notesCtrl.text.trim(),
                          scheduledAt: scheduleCtrl.text.trim().isEmpty
                              ? null
                              : scheduleCtrl.text.trim(),
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

