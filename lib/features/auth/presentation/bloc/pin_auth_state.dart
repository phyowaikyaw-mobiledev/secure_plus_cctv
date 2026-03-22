import 'package:equatable/equatable.dart';

class PinAuthState extends Equatable {
  const PinAuthState({
    required this.isLoading,
    required this.isSaving,
    required this.hasPin,
    required this.isAuthenticated,
    this.errorMessage,
  });

  const PinAuthState.initial()
      : isLoading = true, // ✅ start loading until Hive read finishes
        isSaving = false,
        hasPin = false,
        isAuthenticated = false,
        errorMessage = null;

  final bool isLoading;
  final bool isSaving;
  final bool hasPin;
  final bool isAuthenticated;
  final String? errorMessage;

  /// ✅ Better copyWith:
  /// - If you pass errorMessage, it sets it
  /// - If you want to clear existing errorMessage, set clearError=true
  PinAuthState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? hasPin,
    bool? isAuthenticated,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PinAuthState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      hasPin: hasPin ?? this.hasPin,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSaving,
    hasPin,
    isAuthenticated,
    errorMessage,
  ];
}
