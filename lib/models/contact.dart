// Using DateTime-based ID generation for simplicity

class Contact {
  final String id;
  final String name;
  final String role;
  final String email;
  final String phone;
  final Set<String> tags;
  final String? notes;
  final DateTime dateAdded;
  final DateTime dateModified;

  Contact({
    String? id,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    Set<String>? tags,
    this.notes,
    DateTime? dateAdded,
    DateTime? dateModified,
  })  : id = id ?? 'contact_${DateTime.now().millisecondsSinceEpoch}',
        tags = tags ?? <String>{},
        dateAdded = dateAdded ?? DateTime.now(),
        dateModified = dateModified ?? DateTime.now();

  Contact copyWith({
    String? name,
    String? role,
    String? email,
    String? phone,
    Set<String>? tags,
    String? notes,
    DateTime? dateModified,
  }) {
    return Contact(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      dateAdded: dateAdded,
      dateModified: dateModified ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, role: $role, email: $email, tags: $tags}';
  }
}