part of 'service_request_cubit.dart';

enum ServiceRequestStatus { idle, submitting, success, failure }

class ServiceRequestState extends Equatable {
  const ServiceRequestState({
    required this.status,
    this.errorMessage,
  });

  const ServiceRequestState.initial() : this(status: ServiceRequestStatus.idle);

  final ServiceRequestStatus status;
  final String? errorMessage;

  ServiceRequestState copyWith({
    ServiceRequestStatus? status,
    String? errorMessage,
  }) {
    return ServiceRequestState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

