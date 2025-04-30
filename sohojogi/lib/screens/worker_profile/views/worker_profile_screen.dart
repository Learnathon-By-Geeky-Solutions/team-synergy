import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/screens/worker_profile/view_model/worker_profile_view_model.dart';
import 'package:sohojogi/screens/worker_profile/views/worker_profile_list_view.dart';

class WorkerProfileScreen extends StatelessWidget {
  final String workerId;

  const WorkerProfileScreen({
    super.key,
    required this.workerId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkerProfileViewModel(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          // Add this SafeArea wrapper
          child: WorkerProfileListView(
            workerId: workerId,
            onBackPressed: () => Navigator.pop(context),
            onSharePressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
          ),
        ),
      ),
    );
  }
}