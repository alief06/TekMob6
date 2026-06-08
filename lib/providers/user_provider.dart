import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = 'Alief Al Ikhsan';
  String _email = 'alikhsanalief@gmail.com';
  String _description = 'Warga yang aktif melaporkan kejadian di sekitar untuk lingkungan yang lebih baik dan aman.';
  String _joinedDate = 'Bergabung sejak';
  String _profileImagePath = 'assets/images/profile.png';
  bool _isAccountActive = true;

  String get name => _name;
  String get email => _email;
  String get description => _description;
  String get joinedDate => _joinedDate;
  String get profileImagePath => _profileImagePath;
  bool get isAccountActive => _isAccountActive;
}
