

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:voice_assistant_app/feature_box.dart';
import 'package:voice_assistant_app/openai_service.dart';
import 'package:voice_assistant_app/palette.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:animate_do/animate_do.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  OpenAIService openAIService = OpenAIService();
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  String ?generatedContent;
  String? generatedUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState(){
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  ///initialise the plugin
  Future<void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {

    });  //so that build function rebuilds
  }
  Future<void> initTextToSpeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {

    });
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  /// This callback function returns only when it recognises certain words
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      print("##lastwords "+lastWords);
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
            child: Text("Allen")),
        leading: Icon(Icons.menu),
        centerTitle: true,
      ),
      body:
      Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ZoomIn(
                child: Stack(
                  children: [
                    //virtual assistant pic
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Pallete.assistantCircleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                        Container(
                          height:123,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage('assets/images/virtualAssistant.png',),)
                          ),
                        ),
                  ],
                ),
              ),
              FadeInRight(
                child: Visibility(
                  visible: generatedUrl == null,
                  child: Container(

                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                      top:30,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Pallete.borderColor,
                        ),
                      borderRadius: BorderRadius.circular(20).copyWith(
                        topLeft: Radius.zero,
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        generatedContent == null?
                        "Hey! what can I do for you?" : generatedContent!,
                        style: TextStyle(
                          fontSize: generatedContent == null?25:18,
                          fontFamily: 'Cera Pro',
                          color: Pallete.mainFontColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (generatedUrl != null ) Padding(
                padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                      child: Image(image: NetworkImage(generatedUrl!)))),
              //suggestion
              SlideInLeft(
                child: Visibility(
                  visible: generatedContent == null && generatedUrl==null,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10.0),
                    margin : const EdgeInsets.only(top:10,left:22,),
                    child: const Text("Here are few suggesions",
                    style: TextStyle(
                      fontFamily: 'Cera pro',
                      fontWeight: FontWeight.bold,
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                    ),),
                  ),
                ),
              ),

              //features list
              Visibility(
                visible: generatedContent == null && generatedUrl==null,
                child: Container(
                  child: Column(
                    children: [
                      SlideInLeft(
                        delay: Duration(milliseconds: start),
                        child: FeatureBox(
                            color:Pallete.firstSuggestionBoxColor,
                        headerText : 'ChatGPT',
                        description: "A smarter way to stay organized and informed with chatGPT!",),
                      ),
                      SlideInLeft(
                        delay: Duration(milliseconds: start+delay),
                        child: FeatureBox(
                          color:Pallete.secondSuggestionBoxColor,
                          headerText : 'Dall-E',
                          description: "Get inspired and stay creative with your personal assistant powered by Dall-E",),
                      ),
                      SlideInLeft(
                        delay: Duration(milliseconds: start+2*delay),
                        child: FeatureBox(
                          color:Pallete.thirdSuggestionBoxColor,
                          headerText : 'Smart Voice Assistant',
                          description: "Get the best of both worlds with a voice assistant powered by Dall-E and chatGPT!",),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: SlideInLeft(
        delay: Duration(milliseconds: start+3*delay),
        child: FloatingActionButton(
          onPressed: () async {
            if(await speechToText.hasPermission && speechToText.isNotListening){
              await startListening();
              String res = await openAIService.isArtPromptAPI(lastWords);
              if(res.contains('https')){
                generatedContent = null;
                generatedUrl = res;
                setState(() {

                });
              }
              else{
                generatedUrl = null;
                generatedContent = res;
                setState(() {   //render it on the screen

                });
                await systemSpeak(res);
              }
              print("##result : " + res);
        }
            else if(speechToText.isListening){
              await stopListening();
        }
            else{
              initSpeechToText();  ///ask for permission
            }
        },
          child: Icon(speechToText.isListening?Icons.stop:Icons.mic,),
          backgroundColor: Pallete.firstSuggestionBoxColor,
        ),
      ),
    );
  }
}


