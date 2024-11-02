import 'package:bg/providers/test_provider.dart';
import 'package:bg/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerSheet extends StatefulWidget {
  @override
  _AnswerSheetState createState() => _AnswerSheetState();
}

class _AnswerSheetState extends State<AnswerSheet> {
  final TextEditingController _wordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<TimerProvider>(context, listen: false).startAnswerSheetTimer(context);
  }

  @override
  void dispose() {
    // توقف و ریست کردن تایمر هنگام خروج از صفحه
    TimerProvider().resetTimer(context); // متد ریست کردن تایمر
    _wordController.dispose();


    // زمانی که صفحه ترک می‌شود، حالت تست غیرفعال می‌شود
    //Provider.of<TimerProvider>(context, listen: false).setTestMode(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // دسترسی غیرمستقیم به sessionId از طریق TestProvider
    final testProvider = Provider.of<TestProvider>(context);
    final timerProvider = Provider.of<TimerProvider>(context);

    int? sessionId = testProvider.sessionId;

    return Scaffold(

      backgroundColor: const Color(0xFFE8E8E8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 200.h,),
            Text(
              textAlign: TextAlign.center,
              'ظرف 2 دقیقه لغاتی که به خاطر سپردید را یکی یکی در کادر زیر بنویسید',
              style: TextStyle(
                fontSize: 60.sp,
              ),
            ),
            SizedBox(height: 60.h,),
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
            SizedBox(height: 20),
            _buildInputField(testProvider),
            SizedBox(height: 20),
            _buildResultGrid(testProvider),
            SizedBox(height: 20),
            _buildActionButtons(testProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TestProvider testProvider) {
    return TextField(
      controller: _wordController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: 'لغت را وارد کنید',
      ),
      onSubmitted: (value) {
        print("User input: $value"); // چاپ ورودی کاربر برای دیباگ
        testProvider.checkWord(value);
        _wordController.clear();
      },
    );
  }

  Widget _buildResultGrid(TestProvider testProvider) {
    return Expanded(
      child: Consumer<TestProvider>(
        builder: (context, testProvider, child) {
          return GridView.builder(
            itemCount: testProvider.results.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              String word = testProvider.results[index].keys.first;
              bool isCorrect = testProvider.results[index][word]!;

              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCorrect ? Colors.green : Colors.red, // رنگ صحیح
                    width: 2,
                  ),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(TestProvider testProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 350.w, vertical: 50.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Color(0xFF5052E6),
          ),
          onPressed: () {
            // ذخیره تعداد لغات صحیح در دیتابیس
            int correctWordCount = testProvider.calculateCorrectWords();
            testProvider.saveCorrectWords(context, correctWordCount);
          },
          child: Text(
            'پایان تست',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),

        ),
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //     backgroundColor: Color(0xFFE8E8E8),
        //   ),
        //   onPressed: () {
        //     // عملیات پایان تست و ثبت نتایج
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text("تست به پایان رسید و نتایج ثبت شد.")),
        //     );
        //   },
        //   child: Text(
        //     'پایان تست',
        //     style: TextStyle(color: Colors.black, fontSize: 16),
        //   ),
        // ),
      ],
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
        fontSize: 80.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
