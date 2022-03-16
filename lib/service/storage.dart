class Storage {
  static Future<String?> getDownloadUrl(String path) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'https://firebasestorage.googleapis.com/v0/b/evolum-936c6.appspot.com/o/Get_Lucky.mp3?alt=media&token=4b0da820-c4c6-4de5-a395-9be99e8c3197';
  }
}
