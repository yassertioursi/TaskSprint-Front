class AppConfig {
  // Temporary bearer token - replace with your actual token
  static const String bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTMzMjAzODIsImV4cCI6MTc1MzMyMzk4MiwibmJmIjoxNzUzMzIwMzgyLCJqdGkiOiJGVWVNeFRFejVPN2ZrNzJGIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.5zBYj56O6VCin2A11Z-sUmG2jdRVNXQUImexu0ANCQk";
  
  // Helper method to get authorization header
  static String get authorizationHeader => "Bearer $bearerToken";
}