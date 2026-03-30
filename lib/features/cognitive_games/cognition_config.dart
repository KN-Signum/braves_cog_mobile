import 'package:research_package/research_package.dart';
import 'package:cognition_package/cognition_package.dart';

// Note how steps can be localized by using a translation key and adding
// the translation to the locale files in the 'assets/lang' folder.
final completionStep = RPCompletionStep(
  identifier: 'completion_step',
  title: 'completion_title',
  text: 'completion_text',
);

final tapping = RPTappingActivity(identifier: 'tapping_step');

final reactionTime = RPReactionTimeActivity(identifier: 'reaction_time_step');

final rapidVisualInfoProcessing = RPRapidVisualInfoProcessingActivity(
  identifier: 'RVIP_step',
);

final trailMaking = RPTrailMakingActivity(
  identifier: 'trail_making_step',
  trailType: TrailType.B,
);

final letterTapping = RPLetterTappingActivity(
  identifier: 'letter_tapping_step',
);

final pairedAssociatesLearning = RPPairedAssociatesLearningActivity(
  identifier: 'PAL_step',
);

final corsiBlockTapping = RPCorsiBlockTappingActivity(
  identifier: 'corsi_block_step',
);

final stroopEffect = RPStroopEffectActivity(
  identifier: 'stroop_ffect_step',
  delayTime: 1500,
  displayTime: 1000,
);

final flanker = RPFlankerActivity(identifier: 'flanker_step');

final pictureSequenceMemory = RPPictureSequenceMemoryActivity(
  identifier: 'PSM_step',
);

final wordRecall = RPWordRecallActivity(identifier: 'word_recall_step');

final delayedRecall = RPDelayedRecallActivity(
  identifier: 'delayed_recall_step',
);

final visualArrayChange = RPVisualArrayChangeActivity(identifier: 'VAC_step');

final continuousVisualTracking = RPContinuousVisualTrackingActivity(
  identifier: 'CVT_step',
);
