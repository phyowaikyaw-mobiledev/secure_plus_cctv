import '../../../../../core/firebase/firebase_paths.dart';
import '../../../../../core/firebase/firestore_service.dart';
import '../models/quote.dart';

class QuoteRepository {
  QuoteRepository({FirestoreService? firestore})
      : _firestore = firestore ?? FirestoreService();

  final FirestoreService _firestore;

  Future<void> createQuote(Quote quote) async {
    await _firestore.add(
      FirebasePaths.quotes,
      quote.toMap(),
    );
  }
}

