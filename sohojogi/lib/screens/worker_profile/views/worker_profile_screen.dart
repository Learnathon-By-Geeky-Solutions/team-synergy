import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sohojogi/constants/colors.dart';
import 'package:sohojogi/screens/worker_profile/view_model/worker_profile_view_model.dart';
import 'package:sohojogi/screens/worker_profile/views/worker_profile_list_view.dart';


class WorkerProfileScreen extends StatelessWidget {
  final String workerId;

  const WorkerProfileScreen({
    Key? key,
    required this.workerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkerProfileViewModel(),
      child: Scaffold(
        body: WorkerProfileListView(
          workerId: workerId,
          onBackPressed: () => Navigator.pop(context),
          onSharePressed: () {
            // Implement share functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share functionality coming soon')),
            );
          },
        ),
      ),
    );
  }
}