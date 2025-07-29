import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final textController = TextEditingController();

  void addNewArticle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          TextButton(
            onPressed: () {
              saveArticle();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  final _notesStream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  void saveArticle() async {
    await Supabase.instance.client
        .from('notes')
        .insert({'body': textController.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addNewArticle,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _notesStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final notes = snapshot.data!;

            return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  final noteText = note['body'];
                  return Text(noteText);
                });
          }),
    );
  }
}
