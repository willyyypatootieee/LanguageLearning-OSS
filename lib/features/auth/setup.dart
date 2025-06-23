// Setup main authentication provider
import 'package:provider/provider.dart';

import './viewmodels/auth_viewmodel.dart';

/// Setup authentication provider
class AuthSetup {
  /// Initialize authentication provider
  static List<ChangeNotifierProvider> providers() {
    return [ChangeNotifierProvider(create: (_) => AuthViewModel())];
  }
}
