
// import 'package:flutter/material.dart';

// import '../../../food/domain/entities/food.dart';
// import 'food_card.dart';
// import 'food_section_title.dart';

// class FoodListSection extends StatelessWidget {
//   const FoodListSection({
//     super.key,
//     required this.title,
//     required this.foods,
//     required this.onFoodTap,
//     this.isHorizontal = false,
//     this.onSeeAllTap,
//   });

//   final String title;
//   final List<Food> foods;
//   final ValueChanged<Food> onFoodTap;
//   final bool isHorizontal;
//   final VoidCallback? onSeeAllTap;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         FoodSectionTitle(
//           title: title,
//           actionLabel: 'See all',
//           onActionTap: onSeeAllTap,
//         ),
//         const SizedBox(height: 14),
//         if (isHorizontal)
//           SizedBox(
//             height: 237,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: foods.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 13),
//               itemBuilder: (context, index) {
//                 final food = foods[index];

//                 return FoodCard(
//                   food: food,
//                   onTap: () => onFoodTap(food),
//                 );
//               },
//             ),
//           )
//         else
//           ListView.separated(
//             itemCount: foods.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             separatorBuilder: (_, _) => const SizedBox(height: 13),
//             itemBuilder: (context, index) {
//               final food = foods[index];

//               return Row(
//                 children: [
//                   Expanded(
//                     child: FoodCard(
//                       food: food,
//                       onTap: () => onFoodTap(food),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//       ],
//     );
//   }
// }
