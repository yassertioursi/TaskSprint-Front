class AppConfig {
  // Temporary bearer token - replace with your actual token
  static const String bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTMxOTYwMzgsImV4cCI6MTc1MzE5OTYzOCwibmJmIjoxNzUzMTk2MDM4LCJqdGkiOiJsM3VpSFZMbWpTdGhBekpLIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.-YmHewgsoCNxsQQM65-oHU5exrWxVCs-Keet_ZQfAes";
  
  // Helper method to get authorization header
  static String get authorizationHeader => "Bearer $bearerToken";
}