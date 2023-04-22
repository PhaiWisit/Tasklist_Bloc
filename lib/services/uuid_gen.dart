import 'package:uuid/uuid.dart';

class UniqueIdGenerator {
  final _uuid = Uuid();
  final Set<String> _generatedIds = {};

   String generateUniqueId() {
    String newId;
    do {
      newId = _uuid.v4();
    } while (_generatedIds.contains(newId));
    _generatedIds.add(newId);
    return newId;
  }

  void clearGeneratedIds() {
    _generatedIds.clear();
  }
}