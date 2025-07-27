class AppConfig {
  // Temporary bearer token - replace with your actual token
  static const String bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTM1Nzk0MjIsImV4cCI6MTc1MzU4MzAyMiwibmJmIjoxNzUzNTc5NDIyLCJqdGkiOiJpMmpqZHV1VU9iNG5xanBSIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.YnYA7EW3i-nWxjma4H2CeAdImmALuJbY4-hZOKjzZo0";
  
  // Helper method to get authorization header
  static String get authorizationHeader => "Bearer $bearerToken";
}