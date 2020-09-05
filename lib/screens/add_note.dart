import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/data/note_database.dart';
import 'package:note_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  Note note;

  AddNote({this.note});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int colorIndex = 0;

    final colorList = [
      Color(0xFFFEAA93),
      Color(0xFFFECB86),
      Color(0xFFE6EDA1),
      Color(0xFF82DEE9),
      Color(0xFFCE95D6),
      Color(0xFFF38FB0),
    ];

    Color color = colorList[colorIndex];

    final database = Provider.of<AppDatabase>(context);

    if (widget.note != null) {
      _titleController.text = widget.note.title;
      _descriptionController.text = widget.note.description;
    }

    createNote() {
      Note note = Note(
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        colorValue: color.value,
      );
      database.insertNote(note);
    }

    updateNote() {
      widget.note.title = _titleController.text;
      widget.note.description = _descriptionController.text;
      widget.note.colorValue = color.value;
      database.updateNote(widget.note);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppbar(
              onTap: () {
                widget.note == null ? createNote() : updateNote();
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 25),
            LimitedBox(
              maxHeight: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            color = colorList[index];
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorList[index],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  );
                },
              ),
            ),
            TextField(
              controller: _titleController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(fontSize: 35),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: 35),
              ),
            ),
            SizedBox(height: 20),
            widget.note != null
                ? Text(
                    DateFormat.yMMMMd('en_US').format(widget.note.createdAt),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  )
                : Container(),
            widget.note != null ? SizedBox(height: 20) : Container(),
            TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(fontSize: 22),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type Something...',
                hintStyle: TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.note != null
          ? FloatingActionButton(
              onPressed: () {
                database.deleteNote(widget.note);
                Navigator.pop(context);
              },
              backgroundColor: Colors.red[400],
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            )
          : Container(),
    );
  }
}
