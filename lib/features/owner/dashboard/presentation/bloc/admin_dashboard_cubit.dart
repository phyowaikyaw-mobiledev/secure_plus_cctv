import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/firebase/firebase_paths.dart';
import '../../../../../core/firebase/firestore_service.dart';

part 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  AdminDashboardCubit({
    FirestoreService? firestore,
  })  : _firestore = firestore ?? FirestoreService(),
        super(const AdminDashboardState.initial());

  final FirestoreService _firestore;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final requestsSnapshot = await _firestore
          .instance
          .collection(FirebasePaths.serviceRequests)
          .get();
      final ticketsSnapshot = await _firestore
          .instance
          .collection(FirebasePaths.tickets)
          .get();

      int pending = 0;
      int scheduled = 0;
      int installing = 0;
      int completed = 0;

      for (final doc in requestsSnapshot.docs) {
        final status = (doc.data()['status'] as String? ?? '').toLowerCase();
        switch (status) {
          case 'pending':
            pending++;
            break;
          case 'scheduled':
            scheduled++;
            break;
          case 'installing':
            installing++;
            break;
          case 'completed':
            completed++;
            break;
        }
      }

      int urgentTickets = 0;
      for (final doc in ticketsSnapshot.docs) {
        final urgency = (doc.data()['urgency'] as String? ?? '').toLowerCase();
        if (urgency == 'high') {
          urgentTickets++;
        }
      }

      emit(
        state.copyWith(
          isLoading: false,
          totalRequests: requestsSnapshot.size,
          pendingRequests: pending,
          scheduledRequests: scheduled,
          installingRequests: installing,
          completedRequests: completed,
          urgentTickets: urgentTickets,
        ),
      );
    } on FirebaseException {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage:
              'Unable to load dashboard data. Please check your connection.',
        ),
      );
    }
  }
}

