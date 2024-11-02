import 'package:bg/models/Stroop.dart';
import 'package:bg/providers/user-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bg/providers/timer_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';





class StroopTest extends StatefulWidget {
  const StroopTest({super.key});

  @override
  State<StroopTest> createState() => _StroopTestState();
}

class _StroopTestState extends State<StroopTest> {
  late List<Stroop> stroopWords; // ایجاد متغیر برای ذخیره کلمات

  @override
  void initState() {
    super.initState();

    // بارگذاری کاربر
    context.read<UserProvider>().loadUserFromDatabase().then((_) {
      if (context.read<UserProvider>().currentUser == null) {
        print('Error: Current user is null after loading.');
      } else {
        print('User loaded successfully: ${context.read<UserProvider>().currentUser?.userName}');
      }
    });

    // تولید کلمات و رنگ‌ها
    int sessionId = 5; // برای مثال، sessionId فعلی
    stroopWords = StroopData.generateWordsForSession(sessionId);

    // تنظیم حالت تست
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimerProvider>(context, listen: false).setTestMode(true);
    });

    // نمایش دیالوگ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        headerAnimationLoop: false,
        title: 'عنوان',
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('به سرعت رنگ های کلمات داخل جدول را با صدای بلند بخوانید',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
          ),
        ),
        btnOkOnPress: () {
          Provider.of<TimerProvider>(context, listen: false).toggleTimer(context, TestType.Stroop);
        },
        btnOkText: 'تأیید',
      ).show();
    });
  }

  @override
  void dispose() {
    TimerProvider().resetTimer(context);
    Provider.of<TimerProvider>(context, listen: false).setTestMode(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
            child: Text('تست استروپ',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold))),
      ),
      backgroundColor: const Color(0xFFE8E8E8),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            // نمایش تایمر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTimeContainer(timerProvider.seconds % 10),
                buildTimeContainer(timerProvider.seconds ~/ 10),
                Text(
                  ':',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                buildTimeContainer(timerProvider.minutes % 10),
                buildTimeContainer(timerProvider.minutes ~/ 10),
              ],
            ),
            SizedBox(height: 15.h,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('ثانیه',style: TextStyle(fontSize: 60.sp),),
                  SizedBox(width: 400.w),
                  Text('دقیقه',style: TextStyle(fontSize: 60.sp),),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // تعداد ستون‌ها
                ),
                itemCount: stroopWords.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // پس‌زمینه سفید
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFDEDEDE)), // حاشیه با رنگ #DEDEDE
                    ),
                    child: Center(
                      child: Text(
                        stroopWords[index].word,
                        style: TextStyle(
                          color: stroopWords[index].color, // رنگ کلمه به صورت تصادفی
                          fontSize: 60.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 140, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor : Color(0xFF5052E6), // رنگ دکمه
              ),
              onPressed: () async {
                Provider.of<TimerProvider>(context, listen: false).toggleTimer(context, TestType.Stroop);
              },
              child: Text('پایان', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            SizedBox(height: 20.h,)
          ],
        ),
      ),
    );
  }
}

Widget buildGridButton(String text, Color color) {
  return AspectRatio(
    aspectRatio: 1, // نسبت 1:1 برای ایجاد مربع

    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(

        backgroundColor : color,
        padding: EdgeInsets.all(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // گوشه‌های تیز
        ),

      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: color == Colors.white ? Colors.black : Colors.white,
        ),
      ),
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

// class StroopTest extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تست استروپ'),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3, // تعداد ستون‌ها
//         ),
//         itemCount: stroopWords.length,
//         itemBuilder: (context, index) {
//           return Container(
//             margin: EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Colors.white, // پس‌زمینه سفید
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: stroopWords[index].color), // حاشیه با رنگ کلمه
//             ),
//             child: Center(
//               child: Text(
//                 stroopWords[index].word,
//                 style: TextStyle(
//                   color: stroopWords[index].color, // رنگ کلمه به صورت تصادفی
//                   fontSize: 50.sp,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }