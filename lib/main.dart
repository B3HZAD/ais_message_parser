import 'package:ais_message_parser/ais_message_parser.dart';
import 'package:ais_message_parser/package/model/ais_msg_1.dart';
import 'package:ais_message_parser/package/model/ais_msg_18.dart';
import 'package:ais_message_parser/package/model/ais_msg_24.dart';
import 'package:ais_message_parser/package/model/ais_msg_5.dart';
import 'package:ais_message_parser/package/model/ais_state.dart';
import 'package:ais_message_parser/package/service/handle_massage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ais Message',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Ais Message Parser Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  int selectedItem = 0;
  List<String> messageData = [
    "!AIVDM,1,1,,A,1:0Qah8000Ss@rF?<Euorabr2@Ac,0*16",
    // 1
    "!AIVDM,1,1,,A,5:0Qah82>mcU=<@00004hH6118E=@TLD0000001678:39v6o06C1CQiB000000000000000,2*79!AIVDM,1,1,,B,1815Q=h02A3r`@h>v<uSiS5V0HN8,0*63 ",
    //5
    "!AIVDM,1,1,,A,33naI`02Bp3vo2p>qMFB1iW>002S,0*0E",
    // 3
    "!AIVDM,1,1,,A,B6CdCm0t3`tba35f@V9faHi7kP06,0*58 ",
    //18
    "!AIVDO,1,1,,B,H1c2;qDTijklmno31<<C970`43<1,0*28",
    //24
  ];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String msgData = "";

  void _updateSelectedItem(int index) {
    setState(() {
      widget.selectedItem = index;
    });
    _parseMessage();
  }

  void _parseMessage() {
    setState(() {
      AisMsgState? message =
          parseAisData(data: widget.messageData[widget.selectedItem]);

      if (message != null) {
        ///check message type
        switch (message.msgId) {
          case 1:
          case 3:
            AISMsg1? msg1 = HandleMassage.handleMessage1(message!);
            if (msg1 != null) {
              msgData = msg1.toString();
            }
          case 5:
            AISMsg5? msg5 = HandleMassage.handleMessage5(message!);
            if (msg5 != null) {
              msgData = msg5.toString();
            }

          case 18:
            AISMsg18? msg18 = HandleMassage.handleMessage18(message!);
            if (msg18 != null) {
              msgData = msg18.toString();
            }

          case 24:
            AISMsg24? msg24 = HandleMassage.handleMessage24(message!);
            if (msg24 != null) {
              msgData = msg24.toString();
            }
        }
      } else {
        msgData = "operation failed ...   ";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text("Click on Item to parse message"),
          Expanded(
            flex: 1,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              itemCount: widget.messageData.length,
              itemBuilder: (context, index) {
                print(widget.messageData[index]);
                return InkWell(
                  onTap: () {
                    _updateSelectedItem(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: widget.selectedItem == index
                                ? Colors.green
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          widget.messageData[index],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10),
                          overflow: TextOverflow.fade,
                        )),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.lightGreenAccent),
                  child: Text(
                    '${msgData}',
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
