import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lumina/models/diary_entry.dart';
import 'package:lumina/screens/entry_editor_screen.dart';


class EntryDisplayScreen extends StatelessWidget {
    final DiaryEntry entry;
  const EntryDisplayScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:entry.mood=='Excited' ? Colors.yellow[100] 
                : entry.mood=='Calm' ? Colors.blue[100] 
                : entry.mood=='Peaceful' ? Colors.green[100] 
                : entry.mood=='Sad' ? Colors.blueGrey[100] 
                : Colors.red[100],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          backgroundColor:entry.mood=='Excited' ? Colors.yellow[100] 
                : entry.mood=='Calm' ? Colors.blue[100] 
                : entry.mood=='Peaceful' ? Colors.green[100] 
                : entry.mood=='Sad' ? Colors.blueGrey[100] 
                : Colors.red[100],
          title: Text(DateFormat('dd MMM yyyy').format(entry.createdAt),style: GoogleFonts.indieFlower(color: Colors.black,fontWeight: FontWeight.bold),),
          actions: [
            IconButton(onPressed: (){
               Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => EntryEditorScreen(entry: entry)),
      );
            }, icon: Icon(Icons.edit,color: Colors.black,))
          ],
          
        ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
          child: ListView(           
            children: [
              Text( entry.title.isEmpty ? 'Untitled' : entry.title, style: GoogleFonts.indieFlower(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 40),),
              SizedBox(height: 10,),
              Text(entry.mood, style: GoogleFonts.indieFlower(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 10,),
              Text(entry.content, style: GoogleFonts.indieFlower(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),)
                
          
          
            ],
          ),
        ),
      ),



    );
  }
}