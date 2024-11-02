import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bg/models/user.dart';
import 'package:bg/providers/test_provider.dart';
import 'package:bg/providers/user-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bg/providers/timer_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';


class CountingTest extends StatefulWidget {
  final int sessionId;
  final String testId;
  const CountingTest({super.key, required this.sessionId, required this.testId});

  @override
  State<CountingTest> createState() => _CountingTestState();
}

class _CountingTestState extends State<CountingTest> {
  @override
  void initState() {
    super.initState();
    // فراخوانی متد بارگذاری کاربر به صورت async و منتظر ماندن برای تکمیل آن
    context.read<UserProvider>().loadUserFromDatabase().then((_) {
      // بررسی اینکه آیا کاربر بارگذاری شده است
      if (context.read<UserProvider>().currentUser == null) {
        print('Error: Current user is null after loading.');
      } else {
        print('User loaded successfully: ${context.read<UserProvider>().currentUser?.userName}');
      }
    });
    // تنظیم حالت تست یا تمرین در initState با استفاده از addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimerProvider>(context, listen: false).setTestMode(true);
    });
    // نمایش دیالوگ
    WidgetsBinding.instance.addPostFrameCallback((_) {

      // نمایش دیالوگ
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        headerAnimationLoop: false,
        title: 'عنوان',
        body: Padding(
          padding: const EdgeInsets.all(16.0),  // فاصله‌ی دلخواه
          child: Text( 'برای تست شمارس آماده باشید '
            ,textAlign: TextAlign.center,style:
            TextStyle(fontSize: 50.sp,fontWeight: FontWeight.bold),),
        ),
        btnOkOnPress: () {
          Provider.of<TimerProvider>(context, listen: false).toggleTimer(context, TestType.Counting);

        },
        btnOkText: 'تأیید',
      ).show();
    });
  }
  @override
  void dispose() {
    // توقف و ریست کردن تایمر هنگام خروج از صفحه
    TimerProvider().resetTimer(context); // متد ریست کردن تایمر
    // زمانی که صفحه ترک می‌شود، حالت تست غیرفعال می‌شود
    Provider.of<TimerProvider>(context, listen: false).setTestMode(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return PopScope(
      onPopInvoked: (popInvoked) {
        // لغو تایمر به محض درخواست خروج
        Provider.of<TimerProvider>(context, listen: false).toggleTimer(context, TestType.Counting);
      },
      child: Scaffold(
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
                child: Text('تست شمارش',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold))),
          ),
        backgroundColor: const Color(0xFFF7F7F7),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
              ),

              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 850.w,
                  height: 350.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      'از عدد 1 تا 120 را با صدای بلند بشمارید',

                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/question.png'),

                  TextButton(onPressed: (){}, child: Text('اطلاعات بیشتر درباره این تست',style: TextStyle(fontSize: 40.sp,color:Color(0xFF0367FB), ),),),
                ],
              ),
              SizedBox(height: 250.h,),
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
          SizedBox(height: 30.h,),
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

              Spacer(),
              // دکمه شروع
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 140, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor : Color(0xFF5052E6), // رنگ دکمه
                ),
                onPressed: () async {
                  // در حالت تست
                  await Provider.of<TimerProvider>(context, listen: false).stopTimer(context, TestType.Counting);


                  // گرفتن زمان سپری شده از تایمر به عنوان امتیاز
                  String score = Provider.of<TimerProvider>(context, listen: false).getElapsedTime();

                  // ثبت امتیاز در TestProvider
                  Provider.of<TestProvider>(context, listen: false).updateTestScore(widget.testId, score, widget.sessionId);

                  print('Test score saved: $score');
                },


                child: Text('پایان', style: TextStyle(color: Colors.white, fontSize: 18)), // تغییر متن دکمه
                //child: Text('شروع', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              SizedBox(height: 40),
        ]),
      )),
    );
  }
}

// ویجت برای نمایش هر کادر زمان
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