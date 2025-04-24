import 'package:supabase_flutter/supabase_flutter.dart';
import '../../screens/business_profile/models/worker_registration_model.dart';

class WorkerRegistrationService {
  final supabase = Supabase.instance.client;

  // Get available work types from Supabase
  Future<List<WorkTypeModel>> getWorkTypes() async {
    try {
      final response = await supabase
          .from('work_types')
          .select()
          .order('name');

      return (response as List)
          .map((data) => WorkTypeModel(
        id: data['id'].toString(),
        name: data['name'],
        icon: data['icon'] ?? 'assets/icons/work.png',
      ))
          .toList();
    } catch (e) {
      throw Exception('Failed to load work types: $e');
    }
  }

  // Get available countries from Supabase
  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await supabase
          .from('countries')
          .select()
          .order('name');

      return (response as List)
          .map((data) => CountryModel(
        id: data['id'].toString(),
        name: data['name'],
        flag: data['flag'],
      ))
          .toList();
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }

  // Register a new worker
  Future<Map<String, dynamic>> registerWorker(WorkerRegistrationModel worker) async {
    try {
      // First, insert the worker's basic information
      final workerResponse = await supabase
          .from('workers')
          .insert({
        'full_name': worker.fullName,
        'phone_number': worker.phoneNumber,
        'email': worker.email,
        'years_of_experience': worker.yearsOfExperience,
        'experience_country': worker.experienceCountry,
        'created_at': DateTime.now().toIso8601String(),
      })
          .select()
          .single();

      final workerId = workerResponse['id'];

      // Then, insert the worker's selected work types
      for (var workType in worker.selectedWorkTypes) {
        await supabase.from('worker_work_types').insert({
          'worker_id': workerId,
          'work_type_id': int.parse(workType.id),
        });
      }

      return workerResponse;
    } catch (e) {
      throw Exception('Failed to register worker: $e');
    }
  }
}