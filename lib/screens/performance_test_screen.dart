import 'package:bg/providers/session_provider.dart';
import 'package:bg/screens/counting_test_screen.dart';
import 'package:bg/screens/stroop_test_screen.dart';
import 'package:bg/screens/word_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';



class PerformaceTest extends StatelessWidget {
  const PerformaceTest({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         elevation: 0,
         backgroundColor: Colors.transparent,
         leading: IconButton(
           icon: Icon(Icons.arrow_back),  // آیکون مورد نظر
           onPressed: () {
             Navigator.pop(context);  // بازگشت به صفحه قبلی
           },
         ),
         title: Center(
             child: Text('تست عملکرد مغز',
                 style: TextStyle(
                     color: Colors.black, fontWeight: FontWeight.bold))),
       ),
       backgroundColor: const Color(0xFFF7F7F7),
       body: Padding(
         padding: EdgeInsets.all(30),
         child: Column(
           children: [SizedBox(height: 150.h,),
             Material(
               child: InkWell(
                 onTap: () {
                   // گرفتن Session ID از SessionProvider
                   int sessionId = Provider.of<SessionProvider>(context, listen: false).getCurrentSessionId();

                   Navigator.push(context, MaterialPageRoute(
                     builder: (context) => CountingTest(testId: '1',sessionId:sessionId ,),));
                 },
                 child: Stack(
                   children: [
                     Transform.rotate(
                       angle: -0.03, // Rotates counter-clockwise (radians)

                       child: Container(
                         height: 400.h,
                         width: 900.w,
                         decoration: BoxDecoration(
                           color: Color(0xFFF58949),
                           borderRadius:
                           BorderRadius.circular(20), // گوشه‌های گرد
                         ),
                       ),
                     ),
                     Container(
                       height: 400.h,
                       width: 900.w,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius:
                         BorderRadius.circular(20), // گوشه‌های گرد
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [
                           Image.asset(
                             'assets/images/hand.png', // مسیر تصویر شما
                             width: 80, // عرض تصویر
                             height: 80, // ارتفاع تصویر
                             fit: BoxFit.cover,
                             // نحوه پر شدن تصویر
                           ),
                           Padding(
                             padding: EdgeInsets.all(1.0),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Flexible(
                                   child: Text(
                                     'شمارش اعداد',
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 50.sp,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                                 SizedBox(height: 40.h),
                                 Flexible(
                                   child: Text(
                                     'ارزیابی عملکرد عمومی هر دو نیمکره ',
                                     style: TextStyle(
                                       color: Color(0xFF545454),
                                       fontSize: 30.sp,
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                     Positioned(
                       top: 5,
                       left: 10,
                       child: Container(
                         padding: EdgeInsets.symmetric(horizontal: 1),
                         height: 50.h,
                         width: 20.w,
                         child: Text(
                           '1',
                           style: TextStyle(
                               color: Colors.white.withOpacity(0.3),
                               fontSize: 45.sp),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             SizedBox(
               height: 80.h,
             ),
             Material(
               child: InkWell(
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context) => WordTest(),));
                 },
                 child: Stack(
                   children: [
                     Transform.rotate(
                       angle: -0.03, // Rotates counter-clockwise (radians)

                       child: Container(
                         height: 400.h,
                         width: 900.w,
                         decoration: BoxDecoration(
                           color: Color(0xFF0367FB),
                           borderRadius:
                           BorderRadius.circular(20), // گوشه‌های گرد
                         ),
                       ),
                     ),
                     Container(
                       height: 400.h,
                       width: 900.w,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius:
                         BorderRadius.circular(20), // گوشه‌های گرد
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [
                           Image.asset(
                             'assets/images/word.png', // مسیر تصویر شما
                             width: 80, // عرض تصویر
                             height: 80, // ارتفاع تصویر
                             fit: BoxFit.cover,
                             // نحوه پر شدن تصویر
                           ),
                           Padding(
                             padding: EdgeInsets.all(1.0),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Flexible(
                                   child: Text(
                                     'تست لغات',
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 50.sp,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                                 SizedBox(height: 40.h),
                                 Flexible(
                                   child: Text(
                                     'ارزیابی قشر پره فرونتال نیمکره چپ مغز',
                                     style: TextStyle(
                                       color: Color(0xFF545454),
                                       fontSize: 30.sp,
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                     Positioned(
                       top: 5,
                       left: 10,
                       child: Container(
                         padding: EdgeInsets.symmetric(horizontal: 1),
                         height: 50.h,
                         width: 20.w,
                         child: Text(
                           '1',
                           style: TextStyle(
                               color: Colors.white.withOpacity(0.3),
                               fontSize: 45.sp),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             SizedBox(
               height: 80.h,
             ),
             Material(
               child: InkWell(
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context) => StroopTest(),));
                 },
                 child: Stack(
                   children: [
                     Transform.rotate(
                       angle: -0.03, // Rotates counter-clockwise (radians)

                       child: Container(
                         height: 400.h,
                         width: 900.w,
                         decoration: BoxDecoration(
                           color: Color(0xFF9736EA),
                           borderRadius:
                           BorderRadius.circular(20), // گوشه‌های گرد
                         ),
                       ),
                     ),
                     Container(
                       height: 400.h,
                       width: 900.w,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius:
                         BorderRadius.circular(20), // گوشه‌های گرد
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [
                           Image.asset(
                             'assets/images/stroop.png', // مسیر تصویر شما
                             width: 70, // عرض تصویر
                             height: 70, // ارتفاع تصویر
                             fit: BoxFit.cover,
                             // نحوه پر شدن تصویر
                           ),
                           Padding(
                             padding: EdgeInsets.all(1.0),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Flexible(
                                   child: Text(
                                     'استروپ تست',
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 50.sp,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                                 SizedBox(height: 40.h),
                                 Flexible(
                                   child: Text(
                                     'ارزیابی عمومی قشر پره فرونتال هر دو نیمکره مغز',
                                     style: TextStyle(
                                       color: Color(0xFF545454),
                                       fontSize: 30.sp,
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                     Positioned(
                       top: 5,
                       left: 10,
                       child: Container(
                         padding: EdgeInsets.symmetric(horizontal: 1),
                         height: 50.h,
                         width: 20.w,
                         child: Text(
                           '1',
                           style: TextStyle(
                               color: Colors.white.withOpacity(0.3),
                               fontSize: 45.sp),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),
     );
  }
}
