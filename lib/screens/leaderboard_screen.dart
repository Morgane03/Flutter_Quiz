import 'package:flutter/material.dart';
import '../models/leaderboard_user.dart';
import '../services/leaderboard_service.dart';
import '../assets/const/color.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final service = LeaderboardService();

  late Future<List<LeaderboardUser>> leaderboard;

  @override
  void initState() {
    super.initState();
    leaderboard = service.getLeaderboard();
  }

  Future<void> refresh() async {
    setState(() {
      leaderboard = service.getLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightSable,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder<List<LeaderboardUser>>(
          future: leaderboard,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erreur: ${snapshot.error}"));
            }

            final users = snapshot.data ?? [];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 10),

                /// titre et description
                const Text(
                  "LeaderBoard",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Le top 10 des utilisateurs",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 25),

                /// TROPHY ICON
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: sable,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.emoji_events_outlined,
                      size: 40,
                      color: darkGrey,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// liste des utilisateurs to
                ...users.asMap().entries.map((entry) {
                  final index = entry.key;
                  final user = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        /// rang
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade200,
                          child: Text("${index + 1}"),
                        ),

                        const SizedBox(width: 12),

                        /// info utilisateur (username + nom)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("${user.firstname} ${user.lastname}"),
                            ],
                          ),
                        ),

                        /// SCORE BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: pink,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${user.score}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 20),

                // /// BUTTON HOME
                // Center(
                //   child: ElevatedButton.icon(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFFFF5A5F),
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 24,
                //         vertical: 12,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //     ),
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     icon: const Icon(Icons.home),
                //     label: const Text("Aller à l'accueil"),
                //   ),
                // ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}