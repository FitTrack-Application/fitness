// import 'package:flutter/material.dart';
// import 'package:mobile/features/fitness/viewmodels/diary_viewmodel.dart';
// import 'package:provider/provider.dart';
//
// import '../../../models/exercise.dart';
//
// class ExerciseItemWidget extends StatelessWidget {
//   final Exercise exercise;
//   final VoidCallback onTap;
//
//   const ExerciseItemWidget({super.key, required this.exercise, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;
//     final diaryViewModel = context.watch<DiaryViewModel>();
//     final isAddingThisExercise = diaryViewModel.isAddingExercise(exercise.exerciseId);
//
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//       decoration: BoxDecoration(
//         color: colorScheme.surfaceContainerHighest,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: InkWell(
//               onTap: onTap,
//               borderRadius: BorderRadius.circular(12),
//               child: Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       exercise.name,
//                       style: textTheme.bodyMedium,
//                     ),
//                     Text(
//                       'Muscle: ${exercise.muscleGroup}, Type: ${exercise.type}',
//                       style: textTheme.bodySmall?.copyWith(
//                         color: colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.only(right: 12),
//             decoration: BoxDecoration(
//               color: colorScheme.primaryContainer.withOpacity(0.7),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: InkWell(
//               borderRadius: BorderRadius.circular(20),
//               onTap: isAddingThisExercise
//                   ? null
//                   : () {
//                 diaryViewModel.addExerciseToWorkout(exercise.exerciseId, DateTime.now());
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: isAddingThisExercise
//                     ? SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                     color: colorScheme.onPrimaryContainer,
//                   ),
//                 )
//                     : Icon(Icons.add, color: colorScheme.onPrimaryContainer),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }