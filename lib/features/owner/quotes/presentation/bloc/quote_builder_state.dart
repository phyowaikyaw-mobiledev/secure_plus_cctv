part of 'quote_builder_cubit.dart';

class QuoteBuilderState extends Equatable {
  const QuoteBuilderState({
    required this.items,
    required this.isSaving,
    this.errorMessage,
    this.lastSavedQuote,
  });

  const QuoteBuilderState.initial()
      : items = const [],
        isSaving = false,
        errorMessage = null,
        lastSavedQuote = null;

  final List<QuoteItem> items;
  final bool isSaving;
  final String? errorMessage;
  final Quote? lastSavedQuote;

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.total);

  double get total => subtotal;

  QuoteBuilderState copyWith({
    List<QuoteItem>? items,
    bool? isSaving,
    String? errorMessage,
    Quote? lastSavedQuote,
  }) {
    return QuoteBuilderState(
      items: items ?? this.items,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      lastSavedQuote: lastSavedQuote,
    );
  }

  @override
  List<Object?> get props => [items, isSaving, errorMessage, lastSavedQuote];
}

