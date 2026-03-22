import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    required this.completed,
    this.isLoading = false,
  });

  const OnboardingState.initial()
      : completed = false,
        isLoading = true;

  final bool completed;
  final bool isLoading;

  OnboardingState copyWith({
    bool? completed,
    bool? isLoading,
  }) {
    return OnboardingState(
      completed: completed ?? this.completed,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [completed, isLoading];
}
