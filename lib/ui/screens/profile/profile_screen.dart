import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_analysis_app/core/constants/colors.dart';
import 'package:mental_health_analysis_app/core/constants/strings.dart';
import 'package:mental_health_analysis_app/core/constants/style.dart';
import 'package:mental_health_analysis_app/core/enums/view_state.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_back_button.dart';
import 'package:mental_health_analysis_app/ui/custom_widgets/custom_loader.dart';
import 'package:mental_health_analysis_app/ui/screens/profile/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..initialize(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, _) {
          return Scaffold(
            body: model.state == ViewState.busy
                ? const Center(child: CustomLoader(color: primaryColor))
                : CustomScrollView(
                    slivers: [
                      _buildAppBar(context, model),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                             const SizedBox(height: 24),
                            _buildStatsCards(model),
                            const SizedBox(height: 24),
                            _buildHealthMetrics(model),
                            //const SizedBox(height: 24),
                            // _buildAccountSection(context, model),
                            // const SizedBox(height: 24),
                            //_buildSettingsSection(context),
                            // const SizedBox(height: 24),
                            // _buildLogoutButton(context, model),
                            // const SizedBox(height: 12),
                            // _buildDeleteAccountButton(context, model),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ProfileViewModel model) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xff9BB068),
      leading: CustomBackButton(
        borderColor: Colors.white,
        iconColor: Colors.white,
        onTap: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      actions: [
        // Padding(
        //   padding: const EdgeInsets.only(right: 10),
        //   child: GestureDetector(
        //     onTap: () => _showEditProfileDialog(context, model),
        //     child: Image.asset(
        //       "${AppAssets.iconsPath}/edit.png",
        //       width: 30,
        //       height: 30,
        //     ),
        //   ),
        // ),
        // IconButton(
        //   icon: const Icon(Icons.edit, color: Colors.white),
        //   onPressed: () =>
        // ),
      ],
    );
  }

  Widget _buildStatsCards(ProfileViewModel model) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.chat_bubble_outline,
                value: "${model.totalConversations}",
                label: "Conversations",
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.favorite,
                value: "${model.healthScore}",
                label: "Health Score",
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_emotions,
                value: model.currentMood,
                label: "Current Mood",
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics(ProfileViewModel model) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Health Metrics",
                style: headingTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildMetricRow(
                icon: Icons.bedtime,
                label: "Sleep Quality",
                value: model.sleepQuality,
                color: Colors.purple,
              ),
              const Divider(height: 24),
              _buildMetricRow(
                icon: Icons.psychology,
                label: "Stress Level",
                value: model.stressLevel,
                color: Colors.amber,
              ),
              if (model.concerns.isNotEmpty) ...[
                const Divider(height: 24),
                _buildMetricRow(
                  icon: Icons.warning_amber,
                  label: "Concerns",
                  value: "${model.concerns.length} identified",
                  color: Colors.orange,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
