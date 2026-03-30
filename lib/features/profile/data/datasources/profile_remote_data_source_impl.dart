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

      // Call the activate_user_profile RPC with JSON parameter
      final result = await supabaseClient.rpc(
        'activate_user_profile',
        params: {'profile_data': profileData},
      );

      print("✅ [PROFILE RPC] RPC call successful");
      print("✅ [PROFILE RPC] Result: $result");
    } catch (e) {
      print("❌ [PROFILE RPC] RPC call failed: $e");
      print("❌ [PROFILE RPC] Error type: ${e.runtimeType}");
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Convert profile entity fields to snake_case for database operations.
  /// Only includes fields that differ from the default entity values,
  /// so un-filled onboarding sections don't overwrite existing DB data.
  /// Exception: birth_year, height, weight are always included as mandatory demographic fields.
  Map<String, dynamic> _entityToSnakeCase(UserProfileEntity profile) {
    const defaults = UserProfileEntity();
    final map = <String, dynamic>{};

    // Always send mandatory demographic fields
    map['birth_year'] = profile.birthYear;
    map['height'] = profile.height;
    map['weight'] = profile.weight;

    // Always send substance use booleans — "no" (false) also needs to persist
    map['smoking_cigarettes'] = profile.smokingCigarettes;
    map['drinking_alcohol'] = profile.drinkingAlcohol;
    map['other_substances'] = profile.otherSubstances;

    if (profile.currentIllness != defaults.currentIllness) {
      map['current_illness'] = profile.currentIllness;
    }
    if (profile.chronicDiseases != defaults.chronicDiseases) {
      map['chronic_diseases'] = profile.chronicDiseases;
    }
    if (profile.smokingFrequency != defaults.smokingFrequency) {
      map['smoking_frequency'] = profile.smokingFrequency;
    }
    if (profile.alcoholFrequency != defaults.alcoholFrequency) {
      map['alcohol_frequency'] = profile.alcoholFrequency;
    }
    if (profile.otherSubstancesName != defaults.otherSubstancesName) {
      map['other_substances_name'] = profile.otherSubstancesName;
    }
    if (profile.otherSubstancesFrequency != defaults.otherSubstancesFrequency) {
      map['other_substances_frequency'] = profile.otherSubstancesFrequency;
    }
    if (profile.allergies.isNotEmpty) map['allergies'] = profile.allergies;
    if (profile.medications.isNotEmpty) {
      map['medications'] = profile.medications;
    }
    if (profile.biologicalSex != defaults.biologicalSex) {
      map['biological_sex'] = profile.biologicalSex.value;
    }
    if (profile.genderIdentity != defaults.genderIdentity) {
      map['gender_identity'] = profile.genderIdentity;
    }
    if (profile.genderIdentityOther != defaults.genderIdentityOther) {
      map['gender_identity_other'] = profile.genderIdentityOther;
    }
    if (profile.education != defaults.education) {
      map['education'] = profile.education.value;
    }
    if (profile.educationOther != defaults.educationOther) {
      map['education_other'] = profile.educationOther;
    }
    if (profile.disability != defaults.disability) {
      map['disability'] = profile.disability;
    }
    // 'type' is intentionally excluded — set by admin, not editable by user

    print(
      "🔄 [PROFILE RPC] Non-default fields being sent: ${map.keys.toList()}",
    );
    return map;
  }
}
