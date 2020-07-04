// import 'package:tirthankar/core/const.dart';
// import 'package:flutter/material.dart';

// class CustomTileWidget extends StatelessWidget {  
//   final Widget child;
//   final IconData icon;
//   final String tilename;
//   // final double size;
//   // final double borderWidth;
//   final String image;
//   final bool isActive;
//   final VoidCallback onTap;

//   CustomTileWidget({
//     this.child,
//     this.tilename,
//     this.icon,    
//     @required this.onTap,
//     this.image,
//     this.isActive = false
//    });

//   @override
//   Widget build(BuildContext context) => Column{
    
//       color: AppColors.mainColor,
//       elevation: 14.0,
//       shadowColor: AppColors.styleColor,
//       borderRadius: BorderRadius.circular(24.0),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//         child:Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 //Text
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(tilename,
//                   style:TextStyle(
//                     color: AppColors.styleColor,
//                     fontSize: 20.0,
//                     )
//                   ),
//                 ),
//                 //Icon
//                 Material(
//                   color: AppColors.darkBlue,  
//                   borderRadius: BorderRadius.circular(24.0),
//                   child: Padding(padding: const EdgeInsets.all(16.0),
//                     child: Icon(icon, color: AppColors.lightBlue,size: 30,),                      
//                   ),
//                 ),


//               ],
//             )
//           ],
//         )
//       ),
//       )

          
          
//     return Container(                
//           child: FlatButton(
//             padding: EdgeInsets.all(0),
//             onPressed: onTap, 
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(200),)
//             ),
//             child: child ?? Container(),
//           ) 
//         );    
//   }
// }