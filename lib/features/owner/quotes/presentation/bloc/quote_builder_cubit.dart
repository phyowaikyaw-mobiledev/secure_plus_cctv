import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/quote.dart';
import '../../data/repositories/quote_repository.dart';

part 'quote_builder_state.dart';

class QuoteBuilderCubit extends Cubit<QuoteBuilderState> {
  QuoteBuilderCubit({
    QuoteRepository? repository,
  })  : _repository = repository ?? QuoteRepository(),
        super(const QuoteBuilderState.initial());

  final QuoteRepository _repository;

  void addEmptyItem() {
    final items = List<QuoteItem>.from(state.items)
      ..add(
        QuoteItem(description: '', quantity: 1, unitPrice: 0),
      );
    emit(state.copyWith(items: items));
  }

  void updateItem(
    int index, {
    String? description,
    int? quantity,
    double? unitPrice,
  }) {
    if (index < 0 || index >= state.items.length) return;
    final items = List<QuoteItem>.from(state.items);
    final current = items[index];
    items[index] = QuoteItem(
      description: description ?? current.description,
      quantity: quantity ?? current.quantity,
      unitPrice: unitPrice ?? current.unitPrice,
    );
    emit(state.copyWith(items: items));
  }

  void removeItem(int index) {
    if (index < 0 || index >= state.items.length) return;
    final items = List<QuoteItem>.from(state.items)..removeAt(index);
    emit(state.copyWith(items: items));
  }

  Future<void> saveQuote(String customerName) async {
    if (state.items.isEmpty) return;
    emit(state.copyWith(isSaving: true, errorMessage: null));
    try {
      final quote = Quote(
        id: '',
        customerName: customerName,
        createdAt: DateTime.now(),
        items: state.items,
      );
      await _repository.createQuote(quote);
      emit(state.copyWith(isSaving: false, lastSavedQuote: quote));
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: 'Failed to save quote. Please try again.',
        ),
      );
    }
  }
}

