import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../bloc/quote_builder_cubit.dart';

class QuoteBuilderScreen extends StatefulWidget {
  const QuoteBuilderScreen({super.key});

  @override
  State<QuoteBuilderScreen> createState() => _QuoteBuilderScreenState();
}

class _QuoteBuilderScreenState extends State<QuoteBuilderScreen> {
  final _customerNameCtrl = TextEditingController();

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuoteBuilderCubit()..addEmptyItem(),
      child: BlocConsumer<QuoteBuilderCubit, QuoteBuilderState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
          if (state.lastSavedQuote != null) {
            final quote = state.lastSavedQuote!;
            final buffer = StringBuffer()
              ..writeln('Secure Plus – Quote')
              ..writeln('Customer: ${quote.customerName}')
              ..writeln('Created: ${quote.createdAt}')
              ..writeln('')
              ..writeln('Items:');
            for (final item in quote.items) {
              buffer.writeln(
                  '- ${item.description} x${item.quantity} @ ${item.unitPrice.toStringAsFixed(0)} = ${item.total.toStringAsFixed(0)}');
            }
            buffer.writeln('');
            buffer.writeln('Total: ${quote.total.toStringAsFixed(0)} MMK');
            Share.share(buffer.toString());
          }
        },
        builder: (context, state) {
          return SecureScaffold(
            appBar: AppBar(
              title: const Text('Quote Builder'),
              actions: const [LanguageButton()],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _customerNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Customer / Project name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                TextFormField(
                                  initialValue: item.description,
                                  decoration: const InputDecoration(
                                    labelText: 'Item description',
                                  ),
                                  onChanged: (value) {
                                    context
                                        .read<QuoteBuilderCubit>()
                                        .updateItem(
                                          index,
                                          description: value,
                                        );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue:
                                            item.quantity.toString(),
                                        decoration:
                                            const InputDecoration(
                                          labelText: 'Qty',
                                        ),
                                        keyboardType:
                                            TextInputType.number,
                                        onChanged: (value) {
                                          final qty =
                                              int.tryParse(value) ?? 1;
                                          context
                                              .read<QuoteBuilderCubit>()
                                              .updateItem(
                                                index,
                                                quantity: qty,
                                              );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: item.unitPrice
                                            .toStringAsFixed(0),
                                        decoration:
                                            const InputDecoration(
                                          labelText: 'Unit price',
                                        ),
                                        keyboardType:
                                            TextInputType.number,
                                        onChanged: (value) {
                                          final price =
                                              double.tryParse(value) ??
                                                  0;
                                          context
                                              .read<QuoteBuilderCubit>()
                                              .updateItem(
                                                index,
                                                unitPrice: price,
                                              );
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                      ),
                                      onPressed: () => context
                                          .read<QuoteBuilderCubit>()
                                          .removeItem(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${state.total.toStringAsFixed(0)} MMK',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () => context
                            .read<QuoteBuilderCubit>()
                            .addEmptyItem(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add item'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: 'Save & Share Quote',
                    icon: Icons.share,
                    isBusy: state.isSaving,
                    onPressed: () {
                      context
                          .read<QuoteBuilderCubit>()
                          .saveQuote(_customerNameCtrl.text.trim());
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

