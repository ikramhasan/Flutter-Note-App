import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/data/note_database.dart';
import 'package:note_app/screens/add_note.dart';
import 'package:note_app/widgets/note_card.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    bool hasFound = false;
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notes',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashColor: Colors.blue,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.grey[900],
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: 'Search by title or description',
                              ),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                database.getAllNotes().then((value) {
                                  for (final note in value) {
                                    if ((note.title.toLowerCase() ==
                                            controller.text.toLowerCase()) ||
                                        (note.description.toLowerCase() ==
                                            controller.text.toLowerCase())) {
                                      hasFound = true;
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddNote(note: note),
                                        ),
                                      );
                                    }
                                  }
                                  if (hasFound == false) {
                                    Flushbar(
                                      margin: EdgeInsets.all(20),
                                      dismissDirection:
                                          FlushbarDismissDirection.HORIZONTAL,
                                      borderColor: Colors.red,
                                      borderRadius: 10,
                                      forwardAnimationCurve:
                                          Curves.fastLinearToSlowEaseIn,
                                      messageText:
                                          Text('Could not find relevant note'),
                                    ).show(context);
                                  }
                                });
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Center(
                                      child: FaIcon(FontAwesomeIcons.search)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Ink(
                    padding: EdgeInsets.only(bottom: 5),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Lottie.asset(
                        'assets/animations/search.json',
                        frameRate: FrameRate(60),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: database.watchAllNotes(),
                builder: (context, snapshot) {
                  final notes = snapshot.data ?? List();
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Lottie.asset('assets/animations/loading.json'),
                    );
                  }
                  return snapshot.data.length > 0
                      ? GridView.count(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: List.generate(
                            notes.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                  right: index.isEven ? 10 : 0, bottom: 10),
                              child: NoteCard(note: notes[index]),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\"If you give people nothingness, they can ponder what can be achieved from that nothingness\"',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 25.0),
                                child: Text(
                                  '-Tadao Ando',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddNote()));
        },
        backgroundColor: Colors.greenAccent,
        child: Lottie.asset(
          'assets/animations/add-new.json',
          frameRate: FrameRate(60),
        ),
      ),
    );
  }
}
