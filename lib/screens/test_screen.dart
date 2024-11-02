import 'package:bg/providers/test_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestTable extends StatefulWidget {
  @override
  _TestTableState createState() => _TestTableState();
}

class _TestTableState extends State<TestTable> {
  @override
  void initState() {
    super.initState();
    // بارگذاری تست‌ها
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTests();
    });
  }

  Future<void> _loadTests() async {
    final testProvider = Provider.of<TestProvider>(context, listen: false);
    int? sessionId = testProvider.sessionId;
    await testProvider.printAllTests(); // چاپ تمامی تست‌ها
    print("Current Session ID: $sessionId");

    if (sessionId != null) {
      // چاپ تست‌های ذخیره‌شده
      await testProvider.printStoredTests(sessionId);

      await testProvider.fetchTests(sessionId);
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    final testProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('تست‌های ثبت شده'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: testProvider.tests.isEmpty
            ? Center(child: Text("هیچ تستی ثبت نشده است."))
            : DataTable(
          columns: [
            DataColumn(label: Text('شناسه')),
            DataColumn(label: Text('نوع')),
            DataColumn(label: Text('تاریخ')),
            DataColumn(label: Text('امتیاز')),
          ],
          rows: testProvider.tests.map((test) {
            return DataRow(cells: [
              DataCell(Text(test.id)),
              DataCell(Text(test.type)),
              DataCell(Text(test.date.toString())), // فرمت تاریخ را به شکل دلخواه تغییر دهید
              DataCell(Text(test.score)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
