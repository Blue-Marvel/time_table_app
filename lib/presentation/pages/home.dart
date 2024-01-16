import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_table_app/presentation/pages/add_time_table.dart';
import 'package:time_table_app/provider/time_table_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future timeTableFuture;

  @override
  void initState() {
    timeTableFuture = ref.read(timeTableProvider).getAllTimeTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My time tables'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTimeTableScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: timeTableFuture,
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final listData =
              ref.watch(timeTableProvider).timeTable.reversed.toList();
          return listData.isNotEmpty
              ? ListView.builder(
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddTimeTableScreen(
                              id: listData[index].id.toString(),
                              subject: listData[index].subject,
                              day: listData[index].day,
                              time: listData[index].time,
                            ),
                          ),
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(listData[index].subject),
                            subtitle: Text(listData[index].day),
                            trailing: Text(listData[index].time),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('You don\'t have any time table'),
                );
        },
      ),
    );
  }
}
