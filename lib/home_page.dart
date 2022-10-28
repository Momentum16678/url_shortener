import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_shortener/left_bar.dart';
import 'package:url_shortener/right_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Url Shortener"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60,),
                  const Text("Enter your long URL here",
                  style: TextStyle(
                    fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                            ),
                        ),
                         style: const TextStyle(
                           fontSize: 20,
                         ),
                        textAlign: TextAlign.center,
                        controller: _linkController,
                      )
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () async {
                     final shortenedUrl = await shortenUrl(url: _linkController.text);
                      if(shortenedUrl != null){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return  AlertDialog(
                                title: const Text('Your Shortened Bub-URL'),
                                content: SizedBox(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if(await canLaunchUrl(Uri.parse(shortenedUrl))){
                                                await launchUrl(Uri.parse(shortenedUrl));
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(5)
                                              ),
                                              width: 150,
                                              child: Text(shortenedUrl),
                                            ),
                                          ),
                                          IconButton(onPressed: (){
                                            Clipboard.setData(ClipboardData(text: shortenedUrl)).then((_) =>
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Copied!'))
                                                ));
                                           }, icon: const Icon(Icons.copy))
                                        ],
                                      ),
                                      ElevatedButton.icon(onPressed: (){
                                        _linkController.clear();
                                        Navigator.pop(context);
                                       }, icon: const Icon(Icons.close), label: const Text('Close'))
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      }
                    },
                    child: Container(
                        width: 80,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: const Text(
                            "Bub It",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 40,),
                  const LeftBar(barWidth: 40,),
                  const SizedBox(height: 20,),
                  const LeftBar(barWidth: 70,),
                  const SizedBox(height: 20,),
                  const RightBar(barWidth: 70,),
                  const SizedBox(height: 20,),
                  const RightBar(barWidth: 40,),
                  const SizedBox(height: 20,),
                  const LeftBar(barWidth: 70,),
                  const SizedBox(height: 20,),
                  const LeftBar(barWidth: 40,),
                  const SizedBox(height: 20,),
                  const SizedBox(height: 20,),
                  const RightBar(barWidth: 40,),
                  const SizedBox(height: 20,),
                  const RightBar(barWidth: 70,),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<String?> shortenUrl({required String url}) async {
    try{
      final result = await http.post(
          Uri.parse('https://cleanuri.com/api/v1/shorten'),
          body: {
            'url': url
          }
      );

      if(result.statusCode == 200){
        final jsonResult = jsonDecode(result.body);
        return jsonResult['result_url'];
      }
    }catch (e){
      print('Error ${e.toString()}');
    }
    return null;
  }

}