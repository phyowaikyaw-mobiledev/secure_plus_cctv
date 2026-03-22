part of 'requests_admin_cubit.dart';

enum RequestsAdminStatus { initial, loading, success, failure }

class RequestsAdminState extends Equatable {
  const RequestsAdminState({
    required this.status,
    required this.requests,
    this.errorMessage,
  });

  const RequestsAdminState.initial()
      : status = RequestsAdminStatus.initial,
        requests = const [],
        errorMessage = null;

  final RequestsAdminStatus status;
  final List<ServiceRequest> requests;
  final String? errorMessage;

  RequestsAdminState copyWith({
    RequestsAdminStatus? status,
    List<ServiceRequest>? requests,
    String? errorMessage,
  }) {
    return RequestsAdminState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, requests, errorMessage];
}

