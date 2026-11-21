class ApiConfig {
  static const giphyApiKey = String.fromEnvironment(
    'GIPHY_API_KEY',
    defaultValue: '',
  );
}