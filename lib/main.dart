import 'package:audio_book_app/utils/picker_document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';


void main(){
  runApp(const App());

}
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  FlutterTts tts= FlutterTts();
  void speak(String? text)async{

  await tts.speak(text!)  ;
  }
  void stop()async{
    await tts.stop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("read aloud"),
        actions: [
          IconButton(onPressed: (){
            controller.clear();
          }, icon: const Icon(Icons.delete)),
          IconButton(onPressed: (){
            stop();
          }, icon: const Icon(Icons.stop)),
          IconButton(onPressed: (){
            if(controller.text.isNotEmpty){
              speak(controller.text.trim());
            }
          }, icon: const Icon(Icons.mic)),
        ],
      ), 
      body: Container(padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: controller,
        maxLines: MediaQuery.of(context).size.height.toInt(),
        decoration: const InputDecoration(
          border: InputBorder.none
              ,
          label: Text("Enter text..."),
        ),
      ),),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: (){
       pickDocument().then((value) async {
         if(value!=''){
           //get the file path and decode it with  pdf_text package
           // controller.text=value;
           PDFDoc doc= await PDFDoc.fromPath(value);
           final text= await doc.text;
           controller.text=text;
         }
       });
      },
          label: const Text('pick a pdf file')),
    );
  }
}

