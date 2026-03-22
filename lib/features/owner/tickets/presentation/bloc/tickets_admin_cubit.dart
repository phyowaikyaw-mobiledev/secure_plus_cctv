import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../customer/tickets/data/models/ticket.dart';
import '../../../../customer/tickets/data/repositories/ticket_repository.dart';

part 'tickets_admin_state.dart';

class TicketsAdminCubit extends Cubit<TicketsAdminState> {
  TicketsAdminCubit({
    TicketRepository? repository,
  })  : _repository = repository ?? TicketRepository(),
        super(const TicketsAdminState.initial());

  final TicketRepository _repository;
  StreamSubscription<List<Ticket>>? _sub;

  void start() {
    emit(state.copyWith(status: TicketsAdminStatus.loading));
    _sub?.cancel();
    _sub = _repository.watchTickets().listen(
      (tickets) {
        emit(
          state.copyWith(
            status: TicketsAdminStatus.success,
            tickets: tickets,
          ),
        );
      },
      onError: (_) {
        emit(
          state.copyWith(
            status: TicketsAdminStatus.failure,
            errorMessage:
                'Unable to load tickets. Please try again.',
          ),
        );
      },
    );
  }

  Future<void> updateStatus({
    required String id,
    required String status,
    String? priority,
  }) {
    return _repository.updateStatus(
      id: id,
      status: status,
      priority: priority,
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

