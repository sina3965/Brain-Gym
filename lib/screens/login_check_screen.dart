import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; // اضافه کردن پکیج برای کادرهای ورود کد
import 'package:flutter_screenutil/flutter_screenutil.dart';



class LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 1000.h),
              // عنوان تایید ورود
              Text(
                "تایید ورود",
                style: TextStyle(fontSize: 60.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // توضیحات شماره و کد
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  "کد ارسال شده به شماره 09906198476 را در کادر زیر وارد کنید",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16,color: Color(0xFF545454)),
                ),
              ),
              SizedBox(height: 20.h),

              // تایمر ارسال مجدد
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/clock.png'),
                  SizedBox(width: 8),
                  Text(
                    "48 ثانیه تا ارسال مجدد کد",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // فیلد ورود کد تایید
              Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  keyboardType: TextInputType.number, // تعیین نوع کیبورد به عددی

                  appContext: context,
                  length: 4,
                  obscureText: false,
                  textStyle: TextStyle(fontSize: 20),
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    fieldOuterPadding: EdgeInsets.symmetric(horizontal: 13.w),
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeColor: Colors.grey.shade300,
                    inactiveColor: Colors.grey.shade300,
                    selectedColor: Colors.blue,

                  ),

                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Color(0xFFF7F7F7),
                  enableActiveFill: true,

                  onCompleted: (value) {
                    // اینجا می‌توانید کد وارد شده را بررسی کنید
                  },
                  onChanged: (value) {},
                ),
              ),

              SizedBox(height: 16),

              // لینک شماره اشتباه
              GestureDetector(
                onTap: () {
                  // مسیر جدید را تنظیم کنید
                },
                child: Text(
                  "شماره اشتباه است؟",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5052E6),                  decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 32),

              // دکمه ورود
              ElevatedButton(
                onPressed: () {
                  // عمل ورود
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor : Color(0xFF5052E6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // گرد کردن گوشه‌ها
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 135.w),
                ),
                child: Text(
                  "ورود",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
