import 'package:bg/providers/user-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bg/providers/timer_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';


class WordTest extends StatefulWidget {
  const WordTest ({super.key});

  @override
  State<WordTest> createState() => _WordTestState();
}

class _WordTestState extends State<WordTest> {
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
    // نمایش دیالوگ بلافاصله بعد از لود شدن صفحه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        headerAnimationLoop: false,
        title: 'عنوان',
        body: Padding(
          padding: const EdgeInsets.all(16.0),  // فاصله‌ی دلخواه
          child: Text( '30 لغت را ظرف دو دقیقه حفظ کنید و بعد از آن دو دقیقه برای وارد کردن لغات وقت دارید'
            ,textAlign: TextAlign.center,style:
            TextStyle(fontSize: 50.sp,fontWeight: FontWeight.bold),),
        ),
        btnOkOnPress: () {
          Provider.of<TimerProvider>(context, listen: false).toggleTimer(context, TestType.Vocabulary);

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
            child: Text('تست لغات',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold))),
      ),
      backgroundColor: const Color(0xFFE8E8E8),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),

            Center(
              child: Container(
                alignment: Alignment.center,  // این خط کافی است تا محتوا وسط‌چین شود
                padding: EdgeInsets.all(8),
                width: 900.w,  // از اندازه مورد نظر خود استفاده کنید
                height: 350.h,  // از اندازه مورد نظر خود استفاده کنید
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Text(
                  'در این تست تعداد 30 لغت را مشاهده میکنید که باید در مدت 2 دقیقه هر آنچه که میتوانید را حفظ کرده و پس از 2 دقیقه آن ها را در صفحه بعد بنویسید',
                  textAlign: TextAlign.center,  // این خط متن را وسط‌چین می‌کند
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/question.png'),
                TextButton(onPressed: (){}, child: Text('اطلاعات بیشتر درباره این تست',style: TextStyle(fontSize: 40.sp,color:Color(0xFF0367FB), ),),),
              ],
            ),
            SizedBox(height: 20.h,),
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
            SizedBox(height: 80.h),
            // Grid buttons
            Expanded(
              child: GridView.extent(
              maxCrossAxisExtent: 60, // عرض هر دکمه 100 پیکسل
              crossAxisSpacing: 10, // فاصله بین ستون‌ها
              mainAxisSpacing: 10,
              children: [
                  buildGridButton('راننده', Colors.blue),
                  buildGridButton('رشت', Colors.white),
                  buildGridButton('عالی', Colors.orange),
                  buildGridButton('مدرسه', Colors.purple),
                  buildGridButton('ترک', Colors.white),
                  buildGridButton('اول', Colors.orange),
                  buildGridButton('امام', Colors.white),
                  buildGridButton('کباب', Colors.purple),
                  buildGridButton('دایره', Colors.white),
                  buildGridButton('رسم', Colors.blue),
                  buildGridButton('بیل', Colors.white),
                  buildGridButton('راننده', Colors.blue),
                  buildGridButton('رشت', Colors.white),
                  buildGridButton('عالی', Colors.orange),
                  buildGridButton('مدرسه', Colors.purple),
                  buildGridButton('ترک', Colors.white),
                  buildGridButton('اول', Colors.orange),
                  buildGridButton('امام', Colors.white),
                  buildGridButton('کباب', Colors.purple),
                  buildGridButton('دایره', Colors.white),
                  buildGridButton('رسم', Colors.blue),
                  buildGridButton('بیل', Colors.white),
                  buildGridButton('مدرسه', Colors.purple),
                  buildGridButton('ترک', Colors.white),
                  buildGridButton('اول', Colors.orange),
                  buildGridButton('امام', Colors.white),
                  buildGridButton('کباب', Colors.purple),
                  buildGridButton('دایره', Colors.white),
                  buildGridButton('رسم', Colors.blue),
                  buildGridButton('بیل', Colors.white),
                  // Add more buttons as needed
                ],
              ),
            ),
          ],
        ),
      ),
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


Widget buildGridButton(String text, Color color) {
  return AspectRatio(
    aspectRatio: 1, // نسبت 1:1 برای ایجاد مربع

    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(

        backgroundColor: color,
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