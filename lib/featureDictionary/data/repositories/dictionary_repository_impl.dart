import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/dictionary_local_datasource.dart';

/// Implementation of DictionaryRepository
class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryLocalDataSource _localDataSource;
  Map<String, dynamic>? _memoryCache;

  DictionaryRepositoryImpl(this._localDataSource);

  @override
  Future<void> addRecentSearch(String term) {
    return _localDataSource.addRecentSearch(term);
  }

  @override
  Future<List<String>> getRecentSearches() {
    return _localDataSource.getRecentSearches();
  }

  @override
  Future<void> cachePhoneticData(Map<String, dynamic> phoneticData) async {
    // Update both memory cache and persistent cache
    _memoryCache = phoneticData;
    await _localDataSource.cachePhoneticData(phoneticData);
  }

  @override
  Future<Map<String, dynamic>?> getPhoneticData({
    bool forceRefresh = false,
  }) async {
    try {
      // First check memory cache for best performance
      if (!forceRefresh && _memoryCache != null) {
        print('DEBUG: Using dictionary memory cache');
        return _memoryCache;
      }

      // Then check persistent cache
      if (!forceRefresh) {
        final isCacheValid = await _localDataSource.isCacheValid();

        if (isCacheValid) {
          final cachedData = await _localDataSource.getCachedPhoneticData();
          if (cachedData != null) {
            // Update memory cache
            _memoryCache = cachedData;
            print('DEBUG: Using persistent dictionary cache');
            return cachedData;
          }
        }
      }

      // If we get here, no valid cache was found
      print('DEBUG: No valid dictionary cache found');
      return null;
    } catch (e) {
      print('DEBUG: Error retrieving dictionary data: $e');
      return null;
    }
  }

  @override
  Future<void> clearAllData() async {
    _memoryCache = null;
    await _localDataSource.clearAllData();
  }
}
