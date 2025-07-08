/// Abstract repository interface for dictionary feature
abstract class DictionaryRepository {
  /// Add a term to recent searches
  Future<void> addRecentSearch(String term);

  /// Get list of recent searches
  Future<List<String>> getRecentSearches();

  /// Cache phonetics data
  Future<void> cachePhoneticData(Map<String, dynamic> phoneticData);

  /// Get cached phonetics data if valid
  Future<Map<String, dynamic>?> getPhoneticData({bool forceRefresh = false});

  /// Clear all cached dictionary data
  Future<void> clearAllData();
}
