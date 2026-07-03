import 'package:mobile/_import.dart';

final class HymnNumberType {
  static const String NORMAL = 'NORMAL';
  static const String ADICIONAL = 'ADICIONAL';
}

class HymnsNumber {
  final int id;
  final int num;
  final String code;
  final String label;
  final String type;
  final HymnsGroup hymnsGroup;
  final DateTime? lastAccessedAt;
  final bool isFavorite;
  final int accessCount;

   HymnsNumber({
    required this.id,
    required this.num,
    required this.code,
    required this.label,
    required this.hymnsGroup,
    this.type = HymnNumberType.NORMAL,
    this.lastAccessedAt,
    this.isFavorite = false,
    this.accessCount = 0,
  });

  @override
  String toString() {
    return 'HymnsNumber{id: $id, num: $num, code: $code, label: $label, hymnsGroup: $hymnsGroup}';
  }
}
