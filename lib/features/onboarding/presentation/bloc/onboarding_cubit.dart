import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState(completed: false));

  Future<void> loadStatus() async {
    // Always show onboarding on every launch
    emit(const OnboardingState(completed: false));
  }

  Future<void> complete() async {
    emit(const OnboardingState(completed: true));
  }
}
