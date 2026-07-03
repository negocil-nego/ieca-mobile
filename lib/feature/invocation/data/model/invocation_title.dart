import 'package:mobile/_import.dart';

class InvocationTitle {
  final int id;
  final String name;
  final int position;
  final Section section;
  final DateTime? lastAccessedAt;
  final bool isFavorite;
  final int accessCount;

  const InvocationTitle({
    required this.id,
    required this.name,
    required this.position,
    required this.section,
    this.lastAccessedAt,
    this.isFavorite = false,
    this.accessCount = 0,
  });
}
