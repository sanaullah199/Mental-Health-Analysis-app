import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_loader.dart';
import 'package:mental_health_analysis_app/ui/screens/chat/chat_screen.dart';
import 'package:mental_health_analysis_app/ui/screens/dashboard/dashboard_view_model.dart';
import 'package:mental_health_analysis_app/ui/screens/profile/profile_screen.dart';
import 'package:mental_health_analysis_app/ui/screens/profile/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel()..initialize(),
      child: Consumer<DashboardViewModel>(
        builder: (context, model, _) {
          if (model.state == ViewState.busy) {
            return const Scaffold(
              body: Center(child: CustomLoader(color: primaryColor)),
            );
          }

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: _buildHeader(model),
                    ),
                    const SizedBox(height: 20),

                    _buildMetricsSection(model),
                    const SizedBox(height: 24),
                    _buildAiTherapyChatbot(context, model),
                    const SizedBox(height: 24),
                    _buildRecomendationSection(model),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAiTherapyChatbot(
    BuildContext context,
    DashboardViewModel model,
  ) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 300),
                  () => const ChatScreen(),
                );
              },
              child: Container(
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff5C4033), Color(0xff4A3329)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Robot illustration on the right
                    Positioned(
                      right: -20,
                      top: 20,
                      bottom: 20,
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          "${AppAssets.imagePath}/chat_bot.png",
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Conversation count
                          Text(
                            "Your Mental Wellness Companion",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),

                          SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(right: 35),
                            child: Text(
                              "Tap to begin a reflective session to start a meaningful conversation with your AI Therapist",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          //SizedBox(height: 16),

                          // Text(
                          //   "Start a meaningful conversation with your AI Therapist",
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: Colors.white.withOpacity(0.8),
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    // Action buttons at bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DashboardViewModel model) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.to(
              ProfileScreen(),
              transition: Transition.fadeIn,
              duration: Duration(milliseconds: 300),
            ),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                image:
                    model.currentUser?.profileImage != null &&
                        model.currentUser!.profileImage.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(model.currentUser!.profileImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child:
                  model.currentUser?.profileImage == null ||
                      model.currentUser!.profileImage.isEmpty
                  ? Image.asset("${AppAssets.imagePath}/avator.png")
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "${AppAssets.iconsPath}/calender.png",
                      width: 16,
                      height: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('EEE, dd MMM yyyy').format(DateTime.now()),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Hi, ${model.userName}!",
                  style: headingTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.emoji_emotions, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      model.currentMood,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: primaryColor, size: 28),
            onPressed: () => Get.to(
              SettingsScreen(),
              transition: Transition.fadeIn,
              duration: Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(DashboardViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Mental Health Metrics",
              style: headingTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView(
            padding: EdgeInsets.only(left: 16),
            scrollDirection: Axis.horizontal,
            children: [
              FadeInLeft(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 300),
                child: _buildAnimatedScoreCard(model.healthScore),
              ),
              const SizedBox(width: 12),
              FadeInLeft(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 400),
                child: _buildAnimatedMoodChart(model),
              ),
              const SizedBox(width: 12),
              FadeInLeft(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 500),
                child: _buildAnimatedAnxietyCard(model),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedScoreCard(int score) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: score.toDouble()),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Container(
          width: 163,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xff9BB068), const Color(0xff7A9050)],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff9BB068).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.favorite, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Health Score",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          startDegreeOffset: -90,
                          sectionsSpace: 0,
                          centerSpaceRadius: 45,
                          sections: [
                            PieChartSectionData(
                              value: value,
                              color: Colors.white,
                              radius: 10,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 100 - value,
                              color: Colors.white.withOpacity(0.2),
                              radius: 10,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${value.toInt()}",
                            style: headingTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            _getScoreLabel(value.toInt()),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return "Excellent";
    if (score >= 60) return "Good";
    if (score >= 40) return "Fair";
    return "Needs Care";
  }

  Widget _buildAnimatedMoodChart(DashboardViewModel model) {
    final moodData = [3.0, 4.5, 3.8, 5.2, 6.0, 5.5, 6.8];

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Container(
          width: 163,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange[400]!, Colors.deepOrange[400]!],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Mood",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                model.currentMood,
                style: headingTextStyle.copyWith(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 80,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 8,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          7,
                          (i) => FlSpot(i.toDouble(), moodData[i] * value),
                        ),
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAnxietyCard(DashboardViewModel model) {
    final anxietyScore = model.stressLevel; // 1-5 scale

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: anxietyScore.toDouble()),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Container(
          width: 163,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple[400]!, Colors.deepPurple[400]!],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Stress Level",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  height: 80,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(
                        5,
                        (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: i < value ? 1 : 0.3,
                              color: i < value
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              width: 12,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  "Level ${value.toInt()}/5",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecomendationSection(DashboardViewModel model) {
    final recommendations = model.latestAssessment?.recommendations ?? [];
    final concerns = model.latestAssessment?.concerns ?? [];

    if (recommendations.isEmpty) {
      return FadeInUp(
        duration: const Duration(milliseconds: 600),
        delay: const Duration(milliseconds: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Colors.green[400],
                ),
                const SizedBox(height: 12),
                Text(
                  "You're doing great!",
                  style: headingTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Complete your assessment to get personalized recommendations",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Recommendations",
                      style: headingTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (concerns.isNotEmpty)
                      Text(
                        "${concerns.length} area${concerns.length > 1 ? 's' : ''} to focus on",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${recommendations.length} Tips",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(recommendations.length, (index) {
          final delay = 700 + (index * 100);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
            child: FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: Duration(milliseconds: delay),
              child: _buildRecommendationCard(
                index: index + 1,
                recommendation: recommendations[index],
              ),
            ),
          );
        }),
        if (concerns.isNotEmpty) ...[
          const SizedBox(height: 12),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: 700 + (recommendations.length * 100)),
            child: _buildConcernsCard(concerns),
          ),
        ],
      ],
    );
  }

  Widget _buildRecommendationCard({
    required int index,
    required String recommendation,
  }) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
    ];
    final color = colors[index % colors.length];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "$index",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_outline,
            color: color.withOpacity(0.3),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildConcernsCard(List<String> concerns) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.amber[50]!, Colors.orange[50]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.orange[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Areas of Focus",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: concerns.map((concern) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  concern,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[900],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
