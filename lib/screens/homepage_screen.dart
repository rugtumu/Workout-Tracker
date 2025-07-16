import 'package:flutter/material.dart';
import 'package:workout_tracker/utils/database_helper.dart';
import 'package:workout_tracker/screens/workout_screen.dart';
import 'package:workout_tracker/screens/medical_screen.dart';
import 'package:workout_tracker/screens/profile_screen.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;
  
  // Homepage data
  int _weeklyStreak = 0;
  double? _currentBodyWeight;
  Map<String, dynamic>? _favoriteExercise;
  Map<String, dynamic>? _benchPressPR;
  Map<String, dynamic> _weeklySummary = {};
  String _motivationMessage = '';

  final List<Widget> _screens = [
    const SizedBox.shrink(), // Homepage content is built separately
    const WorkoutScreen(),
    const MedicalScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadHomepageData();
  }

  Future<void> _loadHomepageData() async {
    try {
      final dbHelper = await DatabaseHelper.getInstance();
      
      final streak = await dbHelper.getWeeklyStreak();
      final bodyWeight = await dbHelper.getCurrentBodyWeight();
      final favoriteExercise = await dbHelper.getFavoriteExercise();
      final benchPressPR = await dbHelper.getBenchPressPR();
      final weeklySummary = await dbHelper.getWeeklySummary();
      
      setState(() {
        _weeklyStreak = streak;
        _currentBodyWeight = bodyWeight;
        _favoriteExercise = favoriteExercise;
        _benchPressPR = benchPressPR;
        _weeklySummary = weeklySummary;
        _motivationMessage = _getMotivationMessage(streak, weeklySummary['workout_days']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getMotivationMessage(int streak, int workoutDays) {
    if (streak == 0) {
      return 'The best time to start is now! 💪';
    } else if (streak < 3) {
      return 'Great start! Keep going! 🔥';
    } else if (streak < 8) {
      return 'Incredible consistency! You\'re a machine! ⚡';
    } else if (streak < 12) {
      return 'Legendary! This routine is now part of you! 🏆';
    } else {
      return 'You\'re a legend! Keep it up at this level! 👑';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A3D2A),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A3D2A),
      body: _currentIndex == 0 ? _buildHomepage() : _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          border: Border(
            top: BorderSide(color: Color(0xFF2A2A2A), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1E1E1E),
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Workouts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety),
              label: 'Medical',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomepage() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadHomepageData,
        color: Colors.green,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.fitness_center,
                    color: Colors.green,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Fitness Tracker',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _loadHomepageData,
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Motivation Message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  _motivationMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Streak Card
              _buildStreakCard(),
              
              const SizedBox(height: 16),
              
              // Weekly Summary Card
              _buildWeeklySummaryCard(),
              
              const SizedBox(height: 16),
              
              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildBodyWeightCard()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildBenchPressPRCard()),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Favorite Exercise Card
              _buildFavoriteExerciseCard(),
              
              const SizedBox(height: 24),
              
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.green,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                                 const Text(
                   'Weekly Streak',
                   style: TextStyle(
                     fontSize: 14,
                     color: Colors.white70,
                   ),
                 ),
                const SizedBox(height: 4),
                Text(
                  '$_weeklyStreak weeks',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                                 Text(
                   _weeklyStreak == 0 
                     ? 'No streak yet'
                     : _weeklyStreak == 1 
                       ? 'First week!'
                       : 'Great progress!',
                   style: const TextStyle(
                     fontSize: 12,
                     color: Colors.white54,
                   ),
                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                     const Text(
             'This Week',
             style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
               color: Colors.white,
             ),
           ),
          const SizedBox(height: 16),
          Row(
            children: [
                             Expanded(
                 child: _buildSummaryItem(
                   icon: Icons.calendar_today,
                   label: 'Workout Days',
                   value: '${_weeklySummary['workout_days'] ?? 0}',
                 ),
               ),
               Expanded(
                 child: _buildSummaryItem(
                   icon: Icons.fitness_center,
                   label: 'Total Workouts',
                   value: '${_weeklySummary['total_workouts'] ?? 0}',
                 ),
               ),
               Expanded(
                 child: _buildSummaryItem(
                   icon: Icons.timer,
                   label: 'Duration (min)',
                   value: '${_weeklySummary['total_duration'] ?? 0}',
                 ),
               ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBodyWeightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.monitor_weight,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(height: 8),
                     const Text(
             'Body Weight',
             style: TextStyle(
               fontSize: 12,
               color: Colors.white70,
             ),
           ),
          const SizedBox(height: 4),
                     Text(
             _currentBodyWeight != null 
               ? '${_currentBodyWeight!.toStringAsFixed(1)} kg'
               : 'No data',
             style: const TextStyle(
               fontSize: 16,
               fontWeight: FontWeight.bold,
               color: Colors.white,
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildBenchPressPRCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(height: 8),
          const Text(
            'Bench Press PR',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
                     Text(
             _benchPressPR != null 
               ? '${_benchPressPR!['weight']} kg'
               : 'No data',
             style: const TextStyle(
               fontSize: 16,
               fontWeight: FontWeight.bold,
               color: Colors.white,
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildFavoriteExerciseCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                     const Text(
             'Favorite Exercise',
             style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
               color: Colors.white,
             ),
           ),
          const SizedBox(height: 16),
          if (_favoriteExercise != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _favoriteExercise!['exercise_name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                                             Text(
                         '${_favoriteExercise!['workout_count']} times done • Max: ${_favoriteExercise!['max_weight']} kg',
                         style: const TextStyle(
                           fontSize: 12,
                           color: Colors.white54,
                         ),
                       ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            const Row(
              children: [
                Icon(
                  Icons.favorite_border,
                  color: Colors.white54,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'No exercise data yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }


} 