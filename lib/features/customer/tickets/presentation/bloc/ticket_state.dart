part of 'ticket_cubit.dart';

enum TicketStatus { idle, submitting, success, failure }

class TicketState extends Equatable {
  const TicketState({
    required this.status,
    this.errorMessage,
  });

  const TicketState.initial() : this(status: TicketStatus.idle);

  final TicketStatus status;
  final String? errorMessage;

  TicketState copyWith({
    TicketStatus? status,
    String? errorMessage,
  }) {
    return TicketState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

