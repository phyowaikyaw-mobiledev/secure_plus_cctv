import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PinAuthState extends Equatable {
  final bool isLoading;
  final bool hasPin;
  final bool isUnlocked;
  final String? errorMessage;
  const PinAuthState({required this.isLoading, required this.hasPin, required this.isUnlocked, this.errorMessage});
  const PinAuthState.initial() : isLoading = true, hasPin = false, isUnlocked = false, errorMessage = null;
  PinAuthState copyWith({bool? isLoading, bool? hasPin, bool? isUnlocked, String? errorMessage, bool clearError = false}) {
    return PinAuthState(
      isLoading: isLoading ?? this.isLoading,
      hasPin: hasPin ?? this.hasPin,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
  @override
  List<Object?> get props => [isLoading, hasPin, isUnlocked, errorMessage];
}

class PinAuthCubit extends Cubit<PinAuthState> {
  PinAuthCubit() : super(const PinAuthState.initial());
  static const String _boxName = 'secure_plus_settings';
  static const String _pinKey = 'owner_pin';
  static const String defaultOwnerPin = '940555';
  Box get _box => Hive.box(_boxName);

  Future<void> ensureDefaultPinSeeded() async {
    try {
      final existing = _box.get(_pinKey) as String?;
      if (existing == null || existing.trim().isEmpty) await _box.put(_pinKey, defaultOwnerPin);
      emit(state.copyWith(isLoading: false, hasPin: true, clearError: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, hasPin: false, isUnlocked: false, errorMessage: 'PIN init failed: $e'));
    }
  }

  Future<bool> verifyPin(String pin) async {
    final stored = _box.get(_pinKey) as String?;
    final ok = stored != null && stored == pin.trim();
    emit(state.copyWith(isUnlocked: ok, errorMessage: ok ? null : 'Wrong PIN'));
    return ok;
  }

  // Called after successful username/password login — no PIN needed
  void unlockByLogin() => emit(state.copyWith(isUnlocked: true, clearError: true));

  Future<void> setOrChangePin(String newPin) async {
    final p = newPin.trim();
    if (p.isEmpty) { emit(state.copyWith(errorMessage: 'PIN cannot be empty')); return; }
    await _box.put(_pinKey, p);
    emit(state.copyWith(hasPin: true, clearError: true));
  }

  void lock() => emit(state.copyWith(isUnlocked: false, clearError: true));
  String? getStoredPin() => _box.get(_pinKey) as String?;
}
