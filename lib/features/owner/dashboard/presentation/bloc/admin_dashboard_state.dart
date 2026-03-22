part of 'admin_dashboard_cubit.dart';

class AdminDashboardState extends Equatable {
  const AdminDashboardState({
    required this.isLoading,
    required this.totalRequests,
    required this.pendingRequests,
    required this.scheduledRequests,
    required this.installingRequests,
    required this.completedRequests,
    required this.urgentTickets,
    this.errorMessage,
  });

  const AdminDashboardState.initial()
      : isLoading = false,
        totalRequests = 0,
        pendingRequests = 0,
        scheduledRequests = 0,
        installingRequests = 0,
        completedRequests = 0,
        urgentTickets = 0,
        errorMessage = null;

  final bool isLoading;
  final int totalRequests;
  final int pendingRequests;
  final int scheduledRequests;
  final int installingRequests;
  final int completedRequests;
  final int urgentTickets;
  final String? errorMessage;

  AdminDashboardState copyWith({
    bool? isLoading,
    int? totalRequests,
    int? pendingRequests,
    int? scheduledRequests,
    int? installingRequests,
    int? completedRequests,
    int? urgentTickets,
    String? errorMessage,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      totalRequests: totalRequests ?? this.totalRequests,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      scheduledRequests: scheduledRequests ?? this.scheduledRequests,
      installingRequests: installingRequests ?? this.installingRequests,
      completedRequests: completedRequests ?? this.completedRequests,
      urgentTickets: urgentTickets ?? this.urgentTickets,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        totalRequests,
        pendingRequests,
        scheduledRequests,
        installingRequests,
        completedRequests,
        urgentTickets,
        errorMessage,
      ];
}

