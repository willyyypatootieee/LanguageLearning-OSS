import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/leaderboard_cubit.dart';
import '../../domain/models/leaderboard_user.dart';
import '../../../shared/shared_exports.dart';

class LeaderboardScreen extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavTap;
  const LeaderboardScreen({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
          if (state is LeaderboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LeaderboardLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: Text('#${index + 1}'),
                  title: Text(user.username),
                  subtitle: Text('Score: ${user.scoreEnglish}'),
                  trailing: Text(user.currentRank),
                );
              },
            );
          } else if (state is LeaderboardError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: currentIndex,
        onTap: onNavTap,
      ),
    );
  }
}
