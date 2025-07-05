import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cubit/feeds_cubit.dart';
import 'friend_card.dart';
import 'request_card.dart';

class FriendsManagementWidget extends StatelessWidget {
  const FriendsManagementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6B73FF), Color(0xFF000DFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      _buildTabBar(),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildFriendsList(context),
                            _buildPendingRequestsList(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Text(
            'Teman',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white.withOpacity(0.1),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: [
          Consumer<FeedsCubit>(
            builder: (context, cubit, child) {
              return Tab(text: 'Teman (${cubit.friendsCount})');
            },
          ),
          Consumer<FeedsCubit>(
            builder: (context, cubit, child) {
              return Tab(text: 'Permintaan (${cubit.pendingRequestsCount})');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    return Consumer<FeedsCubit>(
      builder: (context, cubit, child) {
        if (cubit.isLoadingFriends) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (cubit.friends.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada teman',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cari dan tambahkan teman baru!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cubit.friends.length,
          itemBuilder: (context, index) {
            final friend = cubit.friends[index];
            return FriendCard(friend: friend, cubit: cubit);
          },
        );
      },
    );
  }

  Widget _buildPendingRequestsList(BuildContext context) {
    return Consumer<FeedsCubit>(
      builder: (context, cubit, child) {
        if (cubit.isLoadingRequests) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (cubit.pendingRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_outlined,
                  size: 64,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada permintaan',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Permintaan pertemanan akan muncul di sini',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cubit.pendingRequests.length,
          itemBuilder: (context, index) {
            final request = cubit.pendingRequests[index];
            return RequestCard(request: request, cubit: cubit);
          },
        );
      },
    );
  }
}
