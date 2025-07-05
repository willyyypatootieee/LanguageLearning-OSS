// Komponen-komponen untuk fitur feeds dengan gaya permainan
// Header dengan elemen gamifikasi
export 'components/feeds_header.dart';

// Bilah pencarian dengan fitur pencarian lanjutan
export 'components/feeds_search_bar.dart';

// Modal filter untuk menyaring postingan
export 'components/feeds_filter_modal.dart';

// Hasil pencarian pengguna dengan status pertemanan
export 'components/user_search_results.dart';

// Widget untuk manajemen teman
export 'components/friends_management_widget.dart';

// Kartu postingan dengan elemen level dan XP
export 'components/game_post_card.dart';

// Tampilan kosong dengan motivasi untuk membuat postingan
export 'components/game_empty_feeds.dart';

// Modal untuk membuat postingan baru
export 'components/game_create_post_modal.dart';

// Widget animasi untuk loading
export 'components/game_loading_widget.dart';

// Untuk kompatibilitas ke belakang, tetap pertahankan nama widget lama tetapi dengan implementasi baru
import 'components/game_post_card.dart';
import 'components/game_empty_feeds.dart';
import 'components/game_create_post_modal.dart';

// Alias untuk kompatibilitas ke belakang
typedef PostCard = GamePostCard;
typedef EmptyFeedsWidget = GameEmptyFeedsWidget;
typedef CreatePostModal = GameCreatePostModal;
