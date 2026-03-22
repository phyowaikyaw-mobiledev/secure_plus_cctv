part of 'tickets_admin_cubit.dart';

enum TicketsAdminStatus { initial, loading, success, failure }

class TicketsAdminState extends Equatable {
  const TicketsAdminState({
    required this.status,
    required this.tickets,
    this.errorMessage,
  });

  const TicketsAdminState.initial()
      : status = TicketsAdminStatus.initial,
        tickets = const [],
        errorMessage = null;

  final TicketsAdminStatus status;
  final List<Ticket> tickets;
  final String? errorMessage;

  TicketsAdminState copyWith({
    TicketsAdminStatus? status,
    List<Ticket>? tickets,
    String? errorMessage,
  }) {
    return TicketsAdminState(
      status: status ?? this.status,
      tickets: tickets ?? this.tickets,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tickets, errorMessage];
}

