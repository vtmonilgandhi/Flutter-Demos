class User {
  String _username;
  String _password;
  String _email;
  String _city;
  String _birthday;
  int _id;

  User(this._username, this._password, this._email, this._birthday, this._city);

  User.map(dynamic obj) {
    this._username = obj['username'];
    this._password = obj['password'];
    this._email = obj['email'];
    this._birthday = obj['birthday'];
    this._city = obj['city'];
    this._id = obj['id'];
  }

  String get username => _username;

  String get password => _password;

  String get email => _email;

  String get birthday => _birthday;

  String get city => _city;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    map["email"] = _email;
    map["birthday"] = _birthday;
    map["city"] = _city;
    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._username = map["username"];
    this._password = map["password"];
    this._email = map["email"];
    this._birthday = map["birthday"];
    this._city = map["city"];
    this._id = map["id"];
  }
}
