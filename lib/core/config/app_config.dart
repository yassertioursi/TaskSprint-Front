class AppConfig {
  // Temporary bearer token - replace with your actual token
  static const String bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTMxMDkxODUsImV4cCI6MTc1MzExMjc4NSwibmJmIjoxNzUzMTA5MTg1LCJqdGkiOiIzVEg3N2lmbzRjOFJDV2N2Iiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.crhFvBy104dCxFQS_kJvqRSbKDifVl8TOO9ge10yE7E";
  
  // Helper method to get authorization header
  static String get authorizationHeader => "Bearer $bearerToken";
}