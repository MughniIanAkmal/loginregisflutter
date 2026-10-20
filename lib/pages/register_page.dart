import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  bool _isPasswordObscure = true;

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final DateTime initial = _selectedDate ?? DateTime(2000, 1, 1);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        const months = [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];
        _dobController.text =
            '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  void _showNotification(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_outline : Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green.shade600 : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      _showNotification('Mohon lengkapi seluruh form dengan benar');
      return;
    }

    if (_selectedDate == null) {
      _showNotification('Tanggal Lahir wajib dipilih');
      return;
    }

    if (_selectedGender == null) {
      _showNotification('Jenis Kelamin wajib dipilih');
      return;
    }

    final newUser = UserModel(
      fullName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      birthDate: _selectedDate,
      gender: _selectedGender!,
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      address: _addressController.text.trim(),
    );

    final success = AuthService().register(newUser);

    if (success) {
      _showNotification('Registrasi berhasil! Silakan masuk', isSuccess: true);
      Navigator.pop(context); // Kembali ke halaman Login
    } else {
      _showNotification('Username sudah digunakan, pilih username lain');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Daftar Akun Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Lengkapi data diri Anda di bawah ini',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                // 1. Fullname (TextFormField)
                CustomTextField(
                  controller: _fullNameController,
                  labelText: 'Fullname',
                  hintText: 'Contoh: Muhammad Rizki',
                  prefixIcon: Icons.badge_outlined,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Fullname wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                // 2. Username (TextFormField)
                CustomTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  hintText: 'Contoh: mrizki',
                  prefixIcon: Icons.person_outline,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Username wajib diisi';
                    if (v.trim().length < 4) return 'Minimal 4 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 3. Email (TextFormField)
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Contoh: nama@domain.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 4. Tgl Lahir (DatePicker)
                CustomTextField(
                  controller: _dobController,
                  labelText: 'Tanggal Lahir',
                  hintText: 'Pilih tanggal lahir Anda',
                  prefixIcon: Icons.calendar_month_outlined,
                  readOnly: true,
                  onTap: _pickBirthDate,
                  suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Tanggal lahir wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                // 5. Jenis Kelamin (Dropdown)
                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Jenis Kelamin',
                    prefixIcon: const Icon(Icons.wc_outlined, size: 22),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.indigo, width: 2),
                    ),
                  ),
                  hint: const Text('Pilih jenis kelamin'),
                  items: _genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedGender = val),
                  validator: (val) =>
                      val == null ? 'Jenis kelamin wajib dipilih' : null,
                ),
                const SizedBox(height: 16),

                // 6. No.Hp (TextFormField)
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'No. Handphone',
                  hintText: 'Contoh: 08123456789',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'No. HP wajib diisi';
                    if (v.trim().length < 9) return 'Nomor HP minimal 9 digit';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 7. Password (TextFormField, obscureText)
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Minimal 6 karakter',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _isPasswordObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _isPasswordObscure = !_isPasswordObscure),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                    if (v.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 8. Alamat (TextFormField)
                CustomTextField(
                  controller: _addressController,
                  labelText: 'Alamat',
                  hintText: 'Masukkan alamat lengkap tempat tinggal',
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 3,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Alamat wajib diisi' : null,
                ),
                const SizedBox(height: 28),

                // Button Submit
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Submit (Daftar Sekarang)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Navigasi Kembali ke Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Masuk di sini',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
