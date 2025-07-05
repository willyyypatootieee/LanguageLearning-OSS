// Export all game-style feed components
export 'components/feeds_header.dart';
export 'components/feeds_search_bar.dart';
export 'components/feeds_filter_modal.dart';
export 'components/user_search_results.dart';
export 'components/friends_management_widget.dart';
export 'components/game_post_card.dart';
export 'components/game_empty_feeds.dart';
export 'components/game_create_post_modal.dart';
export 'components/game_loading_widget.dart';

// For backward compatibility, keep old widget names but with new implementations
import 'components/game_post_card.dart';
import 'components/game_empty_feeds.dart';
import 'components/game_create_post_modal.dart';

// Backward compatibility aliases
typedef PostCard = GamePostCard;
typedef EmptyFeedsWidget = GameEmptyFeedsWidget;
typedef CreatePostModal = GameCreatePostModal;
