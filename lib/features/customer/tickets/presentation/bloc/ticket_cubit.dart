import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/ticket.dart';
import '../../data/repositories/ticket_repository.dart';

part 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  TicketCubit({
    TicketRepository? repository,
  })  : _repository = repository ?? TicketRepository(),
        super(const TicketState.initial());

  final TicketRepository _repository;

  Future<void> submit({
    required String issueType,
    required String description,
    required String urgency,
    XFile? attachment,
  }) async {
    emit(state.copyWith(status: TicketStatus.submitting));
    try {
      final ticket = Ticket(
        id: '',
        issueType: issueType,
        description: description,
        urgency: urgency,
        photoUrl: null,
        status: 'open',
        createdAt: DateTime.now(),
      );
      await _repository.createTicket(
        ticket: ticket,
        attachment: attachment,
      );
      emit(
        state.copyWith(
          status: TicketStatus.success,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TicketStatus.failure,
          errorMessage: 'Failed to create ticket. Please try again.',
        ),
      );
    }
  }
}

