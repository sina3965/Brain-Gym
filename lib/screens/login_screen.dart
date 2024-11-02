import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 140.h,
              ),
              Center(child: Image.asset('assets/images/blogin.png', errorBuilder: (context, error, stackTrace) {
                return Text('Error loading image');
              }),
              ),
              SizedBox(
                height: 50.h,
              ),
              Text(
                'ورود به اپلیکیشن',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'شماره موبایل خود را وارد کنید ',
              ),
              SizedBox(
                height: 340.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  Image.asset('assets/images/mob.png'),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text('تلفن همراه'),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: TextField(
                  keyboardType: TextInputType.number, // تعیین نوع کیبورد به عددی

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                      border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFDEDEDE),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
          
                  ),
                  ),
                ),
              ),
              SizedBox(
                height: 300.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 70,
                  width: 331,
                  decoration: BoxDecoration(
                    color: Color(0xFF5052E6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                      child: Text(
                    'ارسال کد تایید',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
