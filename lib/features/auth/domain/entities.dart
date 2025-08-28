class UserEntity {
	final String id;
	final String email;
	final String? name;

	UserEntity({
		required this.id,
		required this.email,
		this.name,
	});

	factory UserEntity.fromMap(Map<String, dynamic> map) {
		return UserEntity(
			id: map['id'] as String,
			email: map['email'] as String,
			name: map['name'] as String?,
		);
	}

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'email': email,
			if (name != null) 'name': name,
		};
	}
}

