import 'package:bg/models/exercise.dart';
import 'package:bg/models/session.dart';
import 'package:bg/providers/exercise_provider.dart';
import 'package:bg/providers/session_provider.dart';
import 'package:bg/providers/test_provider.dart';
import 'package:bg/screens/statics.dart';
import 'package:bg/models/test.dart';
import 'package:bg/models/user.dart';
import 'package:bg/providers/question-provider.dart';
import 'package:bg/providers/user-provider.dart';
import 'package:bg/screens/answer_sheet_screen.dart';
import 'package:bg/screens/daily_exercise_screen.dart';
import 'package:bg/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bg/screens/performance_test_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bg/providers/timer_provider.dart';

// تعریف navigatorKey در سطح جهانی
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  await Hive.initFlutter();
  // ثبت TypeAdapter
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TestAdapter());
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SessionProvider()),
          ChangeNotifierProvider(create: (_) => ExerciseProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => QuestionProvider()),

          ChangeNotifierProxyProvider2<SessionProvider, ExerciseProvider, TimerProvider>(
            create: (_) => TimerProvider(),
            update: (_, sessionProvider, exerciseProvider, timerProvider) =>
            timerProvider!..updateProviders(sessionProvider, exerciseProvider),
          ),

          ChangeNotifierProxyProvider<SessionProvider, TestProvider>(
            create: (_) => TestProvider(),
            update: (context, sessionProvider, testProvider) =>
            testProvider!..updateSessionProvider(sessionProvider),
          ),
        ],
        child: MyApp(),
      )

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1080, 2220),
      // اندازه طراحی اولیه (معمولاً بر اساس یک دستگاه مرجع)
      minTextAdapt: true,
      // برای سازگاری بهتر متن
      child: Builder(builder: (context) {
        return MaterialApp(
            theme: ThemeData(
              fontFamily: 'Yekan', // تنظیم فونت پیش‌فرض
              scaffoldBackgroundColor: const Color(
                  0xFFF7F7F7), // تنظیم رنگ پس‌زمینه برای کل صفحه
            ),
            locale: Locale('fa'),
            // تنظیم زبان پیش‌فرض به فارسی
            supportedLocales: const [
              Locale('en'), // انگلیسی
              Locale('fa'), // فارسی
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey, // اضافه کردن navigatorKey

          home: home_page(),
          routes: {
        },
        );
      }),
    );
  }
}

class home_page extends StatelessWidget {
  home_page({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(
        key: _scaffoldKey,

        endDrawer: Drawer(
        child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
        ListTile(
        leading: Icon(Icons.close, color: Colors.black),
    onTap: () {
    Navigator.of(context).pop(); // بستن Drawer
    },
    ),
    ListTile(
    leading: Icon(Icons.home, color: Colors.black),
    title: Text('صفحه اصلی'),
    onTap: () {
    // Action for Home
    },
    ),
    ListTile(
    leading: Icon(Icons.info, color: Colors.black),
    title: Text('درباره ما'),
    onTap: () {
    // Action for About Us
    },
    ),
    ListTile(
    leading: Icon(Icons.phone, color: Colors.black),
    title: Text('تماس با ما'),
    onTap: () {
    // Action for Contact Us
    },
    ),
    ListTile(
    leading: Icon(Icons.more_horiz, color: Colors.black),
    title: Text('دیگر محصولات'),
    onTap: () {
    // Action for More Products
    },
    ),
    ],
    ),
    ),
    //backgroundColor: const Color(0xFFF7F7F7),
    body: Padding(
    padding: const EdgeInsets.all(8.0),
    child: SingleChildScrollView(
    child: Column(
    children: [
    SizedBox(
    height: 60.h,
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    'پرورش مغز',
    style: TextStyle(
    fontSize: 60.sp, fontWeight: FontWeight.bold),
    )
    ],
    ),
    SizedBox(
    height: 60.h,
    ),
    // تصویر brain
    Image.asset('assets/images/logo.png',height: 200.h,width: 800.w),
    SizedBox(
    height: 60.h,
    ),
    // کانتینتر تمرین روزانه
    Material(
    child: InkWell(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => DailyExercise(sessionId: 1,),
    ));
    },
    child: Stack(
    children: [
    Container(
    height: 400.h,
    width: 900.w,
    decoration: BoxDecoration(
    color: Color(0xFFF58949),
    borderRadius:
    BorderRadius.circular(20), // گوشه‌های گرد
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Image.asset(
    'assets/images/b1.png', // مسیر تصویر شما
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
    'تمرینات روزانه',
    style: TextStyle(
    color: Colors.white,
    fontSize: 50.sp,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    SizedBox(height: 30.h),
    Flexible(
    child: Text(
    'هر روز چند دقیقه به پرورش مغز خود بپردازید',
    style: TextStyle(
    color: Colors.white70,
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
    height: 150.h,
    width: 90.w,
    child: Text(
    '1',
    style: TextStyle(
    color: Colors.white.withOpacity(0.3),
    fontSize: 150.sp),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    SizedBox(
    height: 60.h,
    ),
    // کانتینر تست عملکرد مغز
    Stack(
    children: [
    Material(
    child: InkWell(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => PerformaceTest(),
    ));
    },
    child: Container(
    height: 400.h,
    width: 900.w,
    decoration: BoxDecoration(
    color: Color(0xFF0367FB),
    borderRadius:
    BorderRadius.circular(20), // گوشه‌های گرد
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Image.asset(
    'assets/images/b2.png', // مسیر تصویر شما
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
    'تست عملکرد مغز',
    style: TextStyle(
    color: Colors.white,
    fontSize: 50.sp,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    SizedBox(height: 30.h),
    Flexible(
    child: Text(
    'ابتدا ارزیابی قشر پره فرونتال را انجام دهید',
    style: TextStyle(
    color: Colors.white70,
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
    ),
    ),
    Positioned(
    top: 5,
    left: 10,
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 1),
    height: 150.h,
    width: 90.w,
    child: Text(
    '2',
    style: TextStyle(
    color: Colors.white.withOpacity(0.3),
    fontSize: 150.sp),
    ),
    ),
    ),
    ],
    ),
    SizedBox(
    height: 60.h,
    ),
    // کانتینتر ارزیابی عملکرد
    Stack(
    children: [
    Material(
    child: InkWell(
    onTap: () {
    Navigator.push(context, MaterialPageRoute(
    builder: (context) => Statics(),));
    },
    child: Container(
    height: 400.h,
    width: 900.w,
    decoration: BoxDecoration(
    color: Color(0xFF9736EA),
    borderRadius:
    BorderRadius.circular(20), // گوشه‌های گرد
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Image.asset(
    'assets/images/b3.png', // مسیر تصویر شما
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
    'ارزیابی عملکرد',
    style: TextStyle(
    color: Colors.white,
    fontSize: 50.sp,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    SizedBox(height: 30.h),
    Flexible(
    child: Text(
    'در پایان هر هفته خود را ارزیابی کنید       ',
    style: TextStyle(
    color: Colors.white70,
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
    ),
    ),
    Positioned(
    top: 5,
    left: 10,
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 1),
    height: 150.h,
    width: 90.w,
    child: Text(
    '3',
    style: TextStyle(
    color: Colors.white.withOpacity(0.3),
    fontSize: 150.sp),
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    // نوار پایین
    bottomNavigationBar: Container(
    height: 105,
    child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
    // دراور سفارشی
    Builder(
    builder: (context) => InkWell(
    onTap: () {
    Scaffold.of(context).openEndDrawer();
    },
    child: Container(
    width: 70.0,
    height: 70.0,
    decoration: BoxDecoration(
    shape: BoxShape.rectangle,
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    border: Border.all(color: Colors.grey.shade300),
    ),
    child: Center(
    child: Icon(Icons.menu, size: 24.0),
    ),
    ),
    ),
    ),
    //دکمه مرکزی
    Material(
    child: InkWell(
    onTap: () async {
      showDialog(
        context: context,
        builder: (context) {
          return Builder(
            builder: (newContext) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(value: newContext.read<SessionProvider>()),
                  ChangeNotifierProvider.value(value: newContext.read<TimerProvider>()),
                  ChangeNotifierProvider.value(value: newContext.read<TestProvider>()),
                ],
                child: AnswerSheet(),
              );
            },
          );
        },
      );      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      // final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
      //
      // User? currentUser = userProvider.currentUser;
      // if (currentUser == null) {
      //   print('Error: No current user.');
      //   return;
      // }
      //
      // int currentSessionId = sessionProvider.getCurrentSessionId();
      // Exercise newExercise = Exercise(
      //   id: await exerciseProvider.generateExerciseId(),
      //   difficulty: 2,
      //   type: 'Push-Up',
      //   record: '00:45',
      // );
      //
      // await exerciseProvider.addExerciseToSession( currentSessionId, newExercise);
      //

      // Future<void> clearHive() async {
      //   await Hive.deleteBoxFromDisk('userBox');
      //   await Hive.deleteBoxFromDisk('sessionBox');
      //   await Hive.deleteBoxFromDisk('exerciseBox');
      //   await Hive.deleteBoxFromDisk('testBox'); // اگر باکس دیگری دارید
      //   print('All Hive boxes have been deleted.');
      // }
      // clearHive();
      //
      // Future<void> testHive() async {
      //   var userBox = await Hive.openBox<User>('userBox');
      //   User testUser = User(
      //     id: 1,
      //     userName: 'Test User',
      //     startDate: DateTime.now(),
      //     phoneNumber: '0000000000',
      //     sessions: [],
      //   );
      //
      //   await userBox.put(testUser.id, testUser);
      //   User? fetchedUser = userBox.get(testUser.id);
      //   print('Fetched User: ${fetchedUser?.userName}');
      // }
      // testHive();
      // گرفتن اطلاعات کاربر از فرم یا ورودی کاربر
      // String userName = 'John Doe';
      // DateTime startDate = DateTime.now();
      // String phoneNumber = '1234567890';
      //
      // // فراخوانی تابع createUser از UserProvider
      // context.read<UserProvider>().createUser(userName, startDate, phoneNumber);
    },
    child: Container(
    width: 85.0,
    height: 80.0,
    decoration: BoxDecoration(
    shape: BoxShape.rectangle,
    color: Color(0xFF5052E6),
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
    BoxShadow(
    color: Colors.blue.withOpacity(0.6),
    blurRadius: 100,
    offset: Offset(0, 5),
    ),
    ],
    ),
    child: Center(
    child: Image.asset('assets/images/bstorm.png'),
    ),
    ),
    ),
    ),
    //پروفایل
    Material(
    child: InkWell(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => Login(),
    ));
    },
    child: Container(
    width: 70.0,
    height: 70.0,
    decoration: BoxDecoration(
    shape: BoxShape.rectangle,
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    border: Border.all(color: Colors.grey.shade300),
    ),
    child: Center(
    child: Icon(Icons.person, size: 24.0),
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    );
    }
  }
