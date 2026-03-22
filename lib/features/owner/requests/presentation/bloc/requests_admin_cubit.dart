import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../customer/services/data/models/service_request.dart';
import '../../../../customer/services/data/repositories/service_request_repository.dart';

part 'requests_admin_state.dart';

class RequestsAdminCubit extends Cubit<RequestsAdminState> {
  RequestsAdminCubit({
    ServiceRequestRepository? repository,
  })  : _repository = repository ?? ServiceRequestRepository(),
        super(const RequestsAdminState.initial());

  final ServiceRequestRepository _repository;
  StreamSubscription<List<ServiceRequest>>? _sub;

  void start() {
    emit(state.copyWith(status: RequestsAdminStatus.loading));
    _sub?.cancel();
    _sub = _repository.watchRequests().listen(
      (requests) {
        emit(
          state.copyWith(
            status: RequestsAdminStatus.success,
            requests: requests,
          ),
        );
      },
      onError: (_) {
        emit(
          state.copyWith(
            status: RequestsAdminStatus.failure,
            errorMessage:
                'Unable to load service requests. Please try again.',
          ),
        );
      },
    );
  }

  Future<void> updateStatus({
    required String id,
    required String status,
    String? notes,
    String? scheduledAt,
  }) {
    return _repository.updateStatus(
      id: id,
      status: status,
      notes: notes,
      scheduledAt: scheduledAt,
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

