import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth extends ChangeNotifier {
  String? _userId;
  String? _token;
  DateTime? _expiry;
  Timer? _authTimer;

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiry!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return _token != null;
  }

  Future<void> authenticate(
      String? email, String? password, String? keyWord) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$keyWord?key=AIzaSyAjF-ucgVcAE5b3L-CFxGUXxo5sV8xDJR0');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }

      _userId = responseData['localId'];
      _token = responseData['idToken'];
      _expiry = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'token': _token,
        'expiry': _expiry!.toIso8601String(),
        'refreshToken': responseData['refreshToken'],
      });
      prefs.setString('userData', userData);

      keepLoggedIn();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String? email, String? password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String? email, String? password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> keepLoggedIn() async {
    final timeToExpiry = _expiry!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), tryAutoLogin);
  }

  Future<bool> tryAutoLogin() async {
    // GET DATA FROM SHARED PREFERENCES
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiry']);

    // IF EXPIRED
    if (expiryDate.isBefore(DateTime.now())) {
      return refreshToken();
    }

    // IF NOT EXPIRED
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiry = expiryDate;
    notifyListeners();
    return true;
  }

  Future<bool> refreshToken() async {
    // POST HTTP REQUEST
    final url =
        Uri.parse('https://securetoken.googleapis.com/v1/token?key=[API_KEY]');

    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, Object>;

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'grant_type': 'refresh_token',
            'refresh_token': extractedUserData['refreshToken'],
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        return false;
      }
      _token = responseData['id_token'];
      _userId = responseData['user_id'];
      _expiry = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expires_in'],
          ),
        ),
      );
      notifyListeners();

      // STORE DATA IN SHARED PREFERENCES
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiry!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);

      keepLoggedIn();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
