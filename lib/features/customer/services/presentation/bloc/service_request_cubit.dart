import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/service_request.dart';
import '../../data/repositories/service_request_repository.dart';

part 'service_request_state.dart';

class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  ServiceRequestCubit({
    ServiceRequestRepository? repository,
  })  : _repository = repository ?? ServiceRequestRepository(),
        super(const ServiceRequestState.initial());

  final ServiceRequestRepository _repository;

  Future<void> submit({
    required String name,
    required String phone,
    required String township,
    required String address,
    required String locationLink,
    required String premiseType,
    required int cameraCount,
    required String indoorOutdoor,
    required bool remoteView,
    required bool audioRequired,
    required String preferredDateTime,
    required String notes,
    XFile? attachment,
  }) async {
    emit(state.copyWith(status: ServiceRequestStatus.submitting));
    try {
      final req = ServiceRequest(
        id: '',
        name: name,
        phone: phone,
        township: township,
        address: address,
        locationLink: locationLink,
        premiseType: premiseType,
        cameraCount: cameraCount,
        indoorOutdoor: indoorOutdoor,
        remoteView: remoteView,
        audioRequired: audioRequired,
        preferredDateTime: preferredDateTime,
        notes: notes,
        photoUrl: null,
        status: 'pending',
        createdAt: DateTime.now(),
      );
      await _repository.submitRequest(
        request: req,
        attachment: attachment,
      );
      emit(
        state.copyWith(
          status: ServiceRequestStatus.success,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServiceRequestStatus.failure,
          errorMessage: 'Failed to submit request. Please try again.',
        ),
      );
    }
  }
}

