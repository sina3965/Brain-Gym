import 'package:bg/screens/daily_exercise_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Exercise extends StatelessWidget {
  const Exercise({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: Padding(
          padding: EdgeInsets.all(50.0),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Text(
                'تمرینات',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 80.h,
              ),
              Material(
                child: InkWell(
                  // onTap: () {
                  //   Navigator.push(context, MaterialPageRoute(
                  //     builder: (context) => DailyExercise(question: null,),));
                  // },
                  child: Stack(
                    children: [
                      Transform.rotate(
                        angle: -0.03, // Rotates counter-clockwise (radians)

                        child: Container(
                          height: 350.h,
                          width: 800.w,
                          decoration: BoxDecoration(
                            color: Color(0xFFF58949),
                            borderRadius:
                                BorderRadius.circular(20), // گوشه‌های گرد
                          ),
                        ),
                      ),
                      Container(
                        height: 350.h,
                        width: 800.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(20), // گوشه‌های گرد
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/smile.png', // مسیر تصویر شما
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
                                      'تمرین روزانه',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 50.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Flexible(
                                    child: Text(
                                      'هر روز چند دقیقه به پرورش مغز خود بپردازید',
                                      style: TextStyle(
                                        color: Color(0xFF545454),
                                        fontSize: 25.sp,
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
                          width: 50.w,
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
                  // onTap: () {
                  //   Navigator.push(context, MaterialPageRoute(
                  //     builder: (context) => DailyExercise(),));
                  // },
                  child: Stack(
                    children: [
                      Transform.rotate(
                        angle: -0.03, // Rotates counter-clockwise (radians)

                        child: Container(
                          height: 350.h,
                          width: 800.w,
                          decoration: BoxDecoration(
                            color: Color(0xFFF58949),
                            borderRadius:
                                BorderRadius.circular(20), // گوشه‌های گرد
                          ),
                        ),
                      ),
                      Container(
                        height: 350.h,
                        width: 800.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(20), // گوشه‌های گرد
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/wrath.png', // مسیر تصویر شما
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
                                      'تمرین آزاد',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 50.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Flexible(
                                    child: Text(
                                      'با سایر کاربران به رقابت بپردازید                 ',
                                      style: TextStyle(
                                        color: Color(0xFF545454),
                                        fontSize: 25.sp,
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
      ),
    );
  }
}
