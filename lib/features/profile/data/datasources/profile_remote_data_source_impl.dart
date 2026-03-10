import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:braves_cog/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:braves_cog/features/profile/data/models/user_profile_model.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserProfileModel> getUserProfile({String? email}) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Fetch profile from public.profiles table
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileEntity profile) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Convert profile to snake_case JSON for database
      final profileData = _entityToSnakeCase(profile);
      profileData['id'] = userId;

      print("🔄 [PROFILE RPC] Calling activate_user_profile RPC with data:");
      print("🔄 [PROFILE RPC] userId=$userId");
      print("🔄 [PROFILE RPC] profileData keys: ${profileData.keys}");

      // Call the activate_user_profile RPC
      final result = await supabaseClient.rpc(
        'activate_user_profile',
        params: profileData,
      );

      print("✅ [PROFILE RPC] RPC call successful");
      print("✅ [PROFILE RPC] Result: $result");
    } catch (e) {
      print("❌ [PROFILE RPC] RPC call failed: $e");
      print("❌ [PROFILE RPC] Error type: ${e.runtimeType}");
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Convert profile entity fields to snake_case for database operations
  Map<String, dynamic> _entityToSnakeCase(UserProfileEntity profile) {
    return {
      'birth_year': profile.birthYear,
      'height': profile.height,
      'weight': profile.weight,
      'current_illness': profile.currentIllness,
      'chronic_diseases': profile.chronicDiseases,
      'smoking_cigarettes': profile.smokingCigarettes,
      'smoking_frequency': profile.smokingFrequency,
      'drinking_alcohol': profile.drinkingAlcohol,
      'alcohol_frequency': profile.alcoholFrequency,
      'other_substances': profile.otherSubstances,
      'other_substances_name': profile.otherSubstancesName,
      'other_substances_frequency': profile.otherSubstancesFrequency,
      'allergies': profile.allergies,
      'medications': profile.medications,
      'biological_sex': profile.biologicalSex.value,
      'gender_identity': profile.genderIdentity,
      'gender_identity_other': profile.genderIdentityOther,
      'education': profile.education.value,
      'education_other': profile.educationOther,
      'disability': profile.disability,
      'type': profile.type.value,
    };
  }
}
