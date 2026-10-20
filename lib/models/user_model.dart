class UserModel {
  final String fullName;
  final String username;
  final String email;
  final DateTime? birthDate;
  final String gender;
  final String phone;
  final String password;
  final String address;

  UserModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.phone,
    required this.password,
    required this.address,
  });

  String get formattedBirthDate {
    if (birthDate == null) return '-';
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${birthDate!.day} ${months[birthDate!.month - 1]} ${birthDate!.year}';
  }
}
