import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart'; // اضافه کردن این پکیج
import 'package:bg/models/user.dart'; // مدل کاربر شما
//
// class UserProvider with ChangeNotifier {
//   Box<User>? userBox;
//
//   UserProvider() {
//     openBox();
//   }
//   User? _currentUser; // متغیری که کاربر فعلی را نگه می‌دارد
//
//   // Getter برای دسترسی به کاربر فعلی
//   User? get currentUser => _currentUser;
//
//   // تابعی برای تنظیم کاربر فعلی
//   void setCurrentUser(User user) {
//     _currentUser = user;
//     notifyListeners(); // اطلاع دادن به لیسنرها برای بروزرسانی UI
//   }
//   List<User> getAllUsers() {
//     if (userBox == null) {
//       return []; // اگر باکس هنوز باز نشده یا وجود ندارد، یک لیست خالی برمی‌گردانیم
//     }
//
//     return userBox!.values.toList(); // تمامی کاربران ذخیره شده را به صورت یک لیست برمی‌گرداند
//   }
//
//   Future<void> openBox() async {
//     try {
//       userBox = await Hive.openBox<User>('userBox');
//       print('Hive box opened successfully.');
//     } catch (e) {
//       print('Error opening Hive box: $e');
//     }
//   }
//
//   // بارگذاری کاربر از دیتابیس Hive
//   Future<void> loadUserFromDatabase() async {
//     if (userBox == null) {
//       await openBox(); // باکس رو باز می‌کنیم اگر هنوز باز نشده باشه
//     }
//
//     // بررسی اگر کاربر در دیتابیس موجود است
//     if (userBox!.isNotEmpty) {
//       _currentUser = userBox!.getAt(0); // گرفتن اولین کاربر، اگر هست
//       notifyListeners();
//     } else {
//       print('هیچ کاربری در دیتابیس یافت نشد.');
//     }
//   }
//
//
//
//
//   Future<void> addUserOnce(User user) async {
//     if (userBox == null) return;
//
//     // چک کردن اینکه آیا کاربر قبلا ثبت شده است یا نه
//     final existingUser = userBox!.values.firstWhereOrNull(
//           (existingUser) => existingUser.id == user.id,
//     );
//
//     // اگر کاربر قبلاً ثبت نشده باشد، آن را اضافه می‌کنیم
//     if (existingUser == null) {
//       await userBox!.put(user.id, user);
//       notifyListeners();
//     }
//   }
//
//   User? getUser(int id) {
//     return userBox?.get(id);
//   }
//
//   void existUser(User newUser) async {
//     final userBox = await Hive.openBox<User>('userBox');
//
//     // بررسی اینکه آیا کاربر از قبل ثبت شده است یا نه
//     if (!userBox.containsKey(newUser.id)) {
//       await userBox.put(newUser.id, newUser);
//
//       // بررسی وجود کاربر در جعبه
//       User? savedUser = userBox.get(newUser.id);
//
//       if (savedUser != null) {
//         print('کاربر ${newUser.userName} با موفقیت ثبت شد.');
//       } else {
//         print('ثبت کاربر با مشکل مواجه شد.');
//       }
//     } else {
//       print('کاربر با شناسه ${newUser.id} قبلاً ثبت شده است.');
//     }
//   }
//
// }

class UserProvider with ChangeNotifier {
  Box<User>? userBox;

  User? _currentUser; // متغیری که کاربر فعلی را نگه می‌دارد

  // Getter برای دسترسی به کاربر فعلی
  User? get currentUser => _currentUser;

  // تابعی برای تنظیم کاربر فعلی
  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners(); // اطلاع دادن به لیسنرها برای بروزرسانی UI
  }

  // باز کردن باکس Hive به صورت async
  Future<void> openBox() async {
    if (userBox == null || !userBox!.isOpen) {
      try {
        userBox = await Hive.openBox<User>('userBox');
        print('Hive box opened successfully.');
      } catch (e) {
        print('Error opening Hive box: $e');
      }
    }
  }

  // بارگذاری کاربر از دیتابیس Hive
  Future<void> loadUserFromDatabase() async {
    await openBox(); // باکس را باز می‌کنیم اگر هنوز باز نشده باشد

    // بررسی اگر کاربر در دیتابیس موجود است
    if (userBox!.isNotEmpty) {
      _currentUser = userBox!.getAt(0); // گرفتن اولین کاربر، اگر هست
      print('User loaded: ${_currentUser?.userName}');
    } else {
      print('No user found in the database.');
    }

    notifyListeners(); // اطلاع دادن به UI برای بروزرسانی
  }

  // اضافه کردن کاربر جدید به دیتابیس اگر قبلاً ثبت نشده باشد
  Future<void> addUserOnce(User user) async {
    await openBox(); // مطمئن شوید که باکس باز شده است

    // چک کردن اینکه آیا کاربر قبلاً ثبت شده است یا نه
    final existingUser = userBox!.values.firstWhereOrNull(
          (existingUser) => existingUser.id == user.id,
    );

    // اگر کاربر قبلاً ثبت نشده باشد، آن را اضافه می‌کنیم
    if (existingUser == null) {
      await userBox!.put(user.id, user);
      setCurrentUser(user); // کاربر فعلی را تنظیم کنید
      print('User added: ${user.userName}');
    } else {
      print('User already exists: ${user.userName}');
    }
  }

  // گرفتن تمامی کاربران از دیتابیس Hive
  List<User> getAllUsers() {
    if (userBox == null || !userBox!.isOpen) {
      return []; // اگر باکس هنوز باز نشده یا وجود ندارد، یک لیست خالی برمی‌گردانیم
    }

    return userBox!.values.toList(); // تمامی کاربران ذخیره شده را به صورت یک لیست برمی‌گرداند
  }

  // گرفتن کاربر بر اساس ID
  User? getUser(int id) {
    if (userBox != null && userBox!.isOpen) {
      return userBox?.get(id);
    }
    return null;
  }

  // ثبت یا به‌روزرسانی کاربر
  Future<void> existUser(User newUser) async {
    await openBox(); // باکس را باز می‌کنیم اگر هنوز باز نشده باشد

    // بررسی اینکه آیا کاربر از قبل ثبت شده است یا نه
    if (!userBox!.containsKey(newUser.id)) {
      await userBox!.put(newUser.id, newUser);

      User? savedUser = userBox!.get(newUser.id);
      if (savedUser != null) {
        print('User ${newUser.userName} successfully added.');
      } else {
        print('Failed to add user.');
      }
    } else {
      print('User with ID ${newUser.id} already exists.');
    }
  }
  Future<void> createUser(String userName, DateTime startDate, String phoneNumber) async {
    // باز کردن باکس Hive
    await openBox();

    // ایجاد شناسه جدید برای کاربر
    int newUserId = userBox!.isEmpty ? 1 : userBox!.values.last.id + 1;

    // ساخت کاربر جدید با استفاده از اطلاعات ورودی
    User newUser = User(
      id: newUserId,
      userName: userName,
      startDate: startDate,
      phoneNumber: phoneNumber,
      sessions: [], // لیست جلسات خالی برای کاربر جدید
    );

    // اضافه کردن کاربر جدید به باکس Hive
    await userBox!.put(newUser.id, newUser);

    // تنظیم کاربر به عنوان کاربر فعلی
    setCurrentUser(newUser);

    print('User created with ID: ${newUser.id}, Name: ${newUser.userName}');
  }

}

