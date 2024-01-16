import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_table_app/provider/time_table_provider.dart';

class AddTimeTableScreen extends ConsumerStatefulWidget {
  final String id, subject, day, time;
  const AddTimeTableScreen({
    this.id = '',
    this.subject = '',
    this.day = '',
    this.time = '',
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddTimeTableScreenState();
}

TextEditingController subjectController = TextEditingController();
TextEditingController dayController = TextEditingController();
TextEditingController timeController = TextEditingController();

class _AddTimeTableScreenState extends ConsumerState<AddTimeTableScreen> {
  bool isLoading = false;

  @override
  void initState() {
    subjectController.text = widget.subject;
    dayController.text = widget.day;
    timeController.text = widget.time;
    super.initState();
  }

  updateTable() async {
    final timeTable = {
      "id": widget.id,
      "subject": subjectController.text,
      "day": dayController.text,
      "time": timeController.text
    };
    setState(() {
      isLoading = true;
    });
    await ref.read(timeTableProvider).updateTimetable(timeTable: timeTable);
    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  insertTable() async {
    final timeTable = {
      "subject": subjectController.text,
      "day": dayController.text,
      "time": timeController.text
    };
    setState(() {
      isLoading = true;
    });
    await ref.read(timeTableProvider).createNewTimeTable(timeTable: timeTable);
    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add')),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.id == '' ? insertTable : updateTable,
        child: const Icon(Icons.check),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            isLoading ? const LinearProgressIndicator() : const SizedBox(),
            appInput(
                title: 'Subject', textEditingController: subjectController),
            appInput(title: 'Day', textEditingController: dayController),
            appInput(title: 'Time', textEditingController: timeController),
          ],
        ),
      ),
    );
  }

  Widget appInput(
      {required String title,
      required TextEditingController textEditingController}) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: deviceSize.width * 0.05,
          ),
        ),
        SizedBox(
          height: deviceSize.height * 0.02,
        ),
        TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: 'Add $title...',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
