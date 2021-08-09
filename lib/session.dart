class Session {
   final String session_key;
   final String session_expire_date;

  Session({
    required this.session_key,
    required this.session_expire_date,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      session_key: json["session_key"],
      session_expire_date: json["session_expire_date"],
    );
  }
}