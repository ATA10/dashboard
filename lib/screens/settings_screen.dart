import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/user_service.dart';
import '../widgets/custom_appbar.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService();
  late Future<Map<String, dynamic>?> _userData;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _userData = _userService.getUserData();
    _userData.then((data) {
      if (data != null) {
        _nameController.text = data['displayName'] ?? '';
        _emailController.text = data['email'] ?? '';
      }
    });
  }

  void _onTextChanged() {
    setState(() {
      _isChanged = true;
    });
  }

  void _showConfirmationDialog(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              child: Text("Evet"),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() {
    _showConfirmationDialog(
      "Emin misiniz?",
      "Değişiklikleri kaydetmek istiyor musunuz?",
      () async {
        await _userService.updateUserData(displayName: _nameController.text);
        setState(() {
          _isChanged = false;
        });
      },
    );
  }

  void _changePassword() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Şifre Değiştir"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Yeni Şifre",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _userService.updatePassword(passwordController.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Şifre başarıyla değiştirildi.")),
                );
              },
              child: Text("Güncelle"),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() {
    _showConfirmationDialog(
      "Hesabı Sil",
      "Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.",
      () async {
        await _userService.deleteAccount();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hesabınız silindi.")),
        );
        Navigator.pop(context);
      },
    );
  }

  Widget _buildButton({required IconData icon, required String label, required VoidCallback onPressed, Color? color}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          backgroundColor: color ?? Theme.of(context).primaryColor,
        ),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Ayarlar"),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text("Kullanıcı bilgileri yüklenemedi."));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: snapshot.data!['photoUrl'] != null
                        ? NetworkImage(snapshot.data!['photoUrl'])
                        : AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                ),
                SizedBox(height: 20),
                Text("Ad Soyad", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _nameController,
                  onChanged: (value) => _onTextChanged(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Adınızı girin",
                  ),
                ),
                SizedBox(height: 20),
                Text("E-posta", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _emailController,
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                if (_isChanged) _buildButton(
                  icon: Icons.save,
                  label: "Kaydet",
                  onPressed: _saveChanges,
                  color: Colors.green,
                ),
                SizedBox(height: 15),
                _buildButton(
                  icon: FontAwesomeIcons.key,
                  label: "Şifre Değiştir",
                  onPressed: _changePassword,
                ),
                SizedBox(height: 15),
                _buildButton(
                  icon: FontAwesomeIcons.trash,
                  label: "Hesabı Sil",
                  onPressed: _deleteAccount,
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
