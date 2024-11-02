import 'package:bg/models/questions.dart';
import 'package:bg/models/session.dart';
import 'package:bg/providers/exercise_provider.dart';
import 'package:bg/providers/user-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bg/providers/timer_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bg/models/question.dart';

import '../models/exercise.dart';
import '../models/user.dart';
import '../providers/question-provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../providers/session_provider.dart';

Future<User?> fetchUserById(int userId) async {
  var box = await Hive.openBox<User>('userBox');
  return box.get(userId);
}


class DailyExercise extends StatefulWidget {
  // تنظیم حالت تست به false (برای تمرین)
  final int sessionId;

  const DailyExercise({super.key, required this.sessionId});

  @override
  State<DailyExercise> createState() => _DailyExerciseState();
}

class _DailyExerciseState extends State<DailyExercise> {

  @override
  void initState() {
    super.initState();

    // تنظیم حالت تست یا تمرین در initState با استفاده از addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimerProvider>(context, listen: false).setTestMode(false);
    });

// فراخوانی updateProviders برای مقداردهی اولیه به _sessionProvider و _exerciseProvider
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);

    timerProvider.updateProviders(sessionProvider, exerciseProvider);
// بارگذاری کاربر پس از ساخت ویجت
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserFromDatabase(); // بارگذاری کاربر پس از آماده شدن ویجت‌ها
    });


    // استفاده از addPostFrameCallback برای اطمینان از دسترسی به context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // بارگذاری سوالات
      Provider.of<QuestionProvider>(context, listen: false)
          .loadQuestions(widget.sessionId);

      // نمایش دیالوگ
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        headerAnimationLoop: false,
        title: 'عنوان',
        body: Padding(
          padding: const EdgeInsets.all(16.0),  // فاصله‌ی دلخواه
          child: Text( 'با کلیک بر روی دکمه "تایید" تایمر شروع می شود'
              '. اگر جواب سوالی به ذهنتان نرسید روی'
              ' دکمه سوال بعدی کلیک کنید تا جزو آخرین سوالات نمایش داده شود'
            ,textAlign: TextAlign.center,style:
            TextStyle(fontSize: 50.sp,fontWeight: FontWeight.bold),),
        ),
        btnOkOnPress: () {
          Provider.of<TimerProvider>(context, listen: false).toggleTimer(context, TestType.Exercise);

        },
        btnOkText: 'تأیید',
      ).show();

    });
  }
// ویجت سازنده برای هر دکمه عدد
  Widget buildNumberButton(String number) {
    final questionProvider = Provider.of<QuestionProvider>(context, listen: false);

    return Container(
      height: 80, // ارتفاع ثابت برای دکمه‌ها
      child: Center(
        child: TextButton(
          onPressed: () {
            // اضافه کردن عدد به پاسخ کاربر
            questionProvider.updateUserAnswer(number, context);
            print(number);
          },
          child: Text(
            number,
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,

            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // توقف و ریست کردن تایمر هنگام خروج از صفحه
    TimerProvider().resetTimer(context); // متد ریست کردن تایمر
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final questionProvider = Provider.of<QuestionProvider>(context);
    final timerProvider = Provider.of<TimerProvider>(context);
    bool isItNext = false;

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
            child: Text('تمرین روزانه',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold))),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            // نمایش تایمر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTimeContainer(timerProvider.seconds % 10),  // رقم دوم ثانیه
                buildTimeContainer(timerProvider.seconds ~/ 10), // رقم اول ثانیه


                Text(
                  ':',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                buildTimeContainer(timerProvider.minutes % 10),  // رقم دوم دقیقه
                buildTimeContainer(timerProvider.minutes ~/ 10), // رقم اول دقیقه

              ],
            ),
            SizedBox(height: 80.h,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text('ثانیه'),
            //
            //     SizedBox(width: 40),
            //     Text('دقیقه'),
            //   ],
            // ),
            SizedBox(height: 110.h),
            Container(
              height: 350.h,
              width: 800.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // نمایش سوال فعلی
                  if (questionProvider.hasMoreQuestions())

                    Directionality(
                      textDirection: TextDirection.ltr, // تنظیم جهت راست به چپ
                      child: Text(
                        questionProvider.getCurrentQuestion().questionText,
                        style: TextStyle(fontSize: 150.sp, fontWeight: FontWeight.bold,color: Color(0xFF5052E6),),
                      ),
                    ),

                ],
              ),
            ),
            SizedBox(height: 210.h,),
            // Grid برای نمایش اعداد
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(width: 1, color: Colors.black12),
                ),
                children: [
                  // ردیف اول
                  TableRow(
                    children: [
                      buildNumberButton('۳'),
                      buildNumberButton('۲'),
                      buildNumberButton('۱'),

                    ],
                  ),
                  // ردیف دوم
                  TableRow(
                    children: [
                      buildNumberButton('۶'),
                      buildNumberButton('۵'),
                      buildNumberButton('۴'),
                    ],
                  ),
                  // ردیف سوم
                  TableRow(
                    children: [
                      buildNumberButton('۹'),
                      buildNumberButton('۸'),
                      buildNumberButton('۷'),

                    ],
                  ),
                  // ردیف چهارم: عدد صفر و دکمه‌های "سوال بعدی" و "پاک کردن"
                  TableRow(
                    children: [
                      IconButton(
                        onPressed: () {
                          // پاک کردن ورودی
                          questionProvider.clearUserAnswer();
                        },
                        icon: Icon(Icons.close, color: Colors.blue),
                      ),
                      buildNumberButton('۰'),
                      buildControlButton(
                          icon: Icons.skip_next,
                          label: 'سوال بعدی',
                          onPressed: () {
                            // عملیات سوال بعدی
                            if (questionProvider.hasMoreQuestions())
                              // حرکت به سوال بعدی
                              questionProvider.goToNextQuestion(context);
                          }
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeBox extends StatelessWidget {
  final String text;
  TimeBox(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}



// ویجت سازنده برای دکمه سوال بعدی
Widget buildControlButton({required IconData icon, required String label, required VoidCallback onPressed}) {
  return TextButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, color: Colors.blue),
    label: Text(
      label,
      style: TextStyle(color: Colors.blue, ),
    ),
  );
}

Widget buildTimeContainer(int timeDigit) {
  return Container(
    width: 160.w,
    height: 200.h,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),

    ),
    child: Text(
      timeDigit.toString(),
      style: TextStyle(
        fontSize: 120.sp,
        fontWeight: FontWeight.bold,
      ),
    ),

  );
}
