// import 'package:calender_app/src/functions/common.dart';
// import 'package:calender_app/src/functions/errorHandling.dart';
// import 'package:calender_app/src/resources/getKeyApi.dart';
// import 'package:calender_app/src/style/theme.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/classes/event.dart';

// import '../calender/calender1.dart' as calender;

// // we have changed the event class of calender carousal and added two more feild 'tag' and 'uKey'
// bool _isLoading = false;
// TextEditingController _eventController = TextEditingController();
// _handleSubmit(
//   BuildContext context,
//   DateTime date,
//   dynamic notifySend,
//   dynamic notifyP,
//   String type,
// ) async {
//   // var form = _eventFormKey.currentState;
//   // if (form.validate()) {
//   // print("form validated");
//   // add on success
//   _isLoading = true;
//   // notify1();
//   notifySend();
//   if (_eventController.text == "") {
//     _sendAvailable = true;
//     _isLoading = false;
//     // notify1();

//     notifySend();
//     return;
//   }
//   await getKey().then((val) async {
//     String _uKey = val;
//     calender.taskEventList.add(_eventController.text);
//     calender.taskKeyList.add(_uKey);

//     Event event = Event(
//       date: date,
//       title: _eventController.text,
//       icon: calender.eventIcon,
//       uKey: _uKey,
//       tag: type,
//     );

//     String formattedDate = date.toString().substring(0, 10);
//     String path = 'user/${calender.uid}/taskDate';
//     Map<String, dynamic> data = {
//       "title": _eventController.text,
//       "key": _uKey,
//       "tag": type,
//       "icon": "icons",
//     };

//     bool exist = false;
//     if (calender.taskDateMap == null) {
//       exist = false;
//     } else
//       exist = calender.taskDateMap?.containsKey(formattedDate) ?? false;
//     if (exist) {
//       // update.update(formattedDate, data);
//       print(
//           "type check9999999999 ${calender.taskDateMap[formattedDate].runtimeType}");
//       // calender.taskDateMap[formattedDate].add(data);
//       var r =
//           List<Map<dynamic, dynamic>>.from(calender.taskDateMap[formattedDate]);
//       r.add(data);

//       calender.taskDateMap[formattedDate] = r;
//       // print("r ggere is $r");
//       // print("r ggere is ${r.runtimeType}");
//     } else {
//       calender.taskDateMap[formattedDate] = [
//         data,
//       ];
//     }

//     Map<String, dynamic> update =
//         calender.taskDateMap.map((k, v) => MapEntry(k, v));
//     try {
//       await calender.updateMap(path, update);
//     } catch (e) {
//       _isLoading = false;
//       _sendAvailable = true;

//       notifySend();
//       // notify1();
//       notifyP();
//     }

//     calender.markedDateMap.add(date, event);
//     // do firebse logic here

//     notifyP();
//     // do when success
//     Navigator.pop(context);
//     _eventController.clear();
//     // _eventController?.dispose();

//     notifySend();
//   }).catchError((e) {
//     print("error is $e");

//     _isLoading = true;
//     _sendAvailable = true;
//     // notify1();
//     notifyP();

//     notifySend();
//     errorDialog(
//       context,
//       "Try Again",
//       "Check your internet connection",
//     );
//   }); // check what happen in case of failure
//   // }
// }

// // RenderFlex overflowed by 1.00 pixels on the bottom due to next list tile
// List<String> name = [
//   "Mark PL",
//   "Mark CL",
// ];
// void addEventBottomSheet(
//   BuildContext context,
//   DateTime dateSelected,
//   dynamic notify,
//   String type,
// ) {
//   Widget chipSelect(String name, int index) {
//     return GestureDetector(
//       onTap: () {
//         if (!_isLoading) {
//           print("check clicked send");
//           _eventController.text = name;
//           // return _handleSubmit(
//           //   context,
//           //   dateSelected,
//           //   notify1,
//           //   notify2,
//           //   type,
//           // );
//         } else {
//           print("check clicked send");
//           return null;
//         }
//       },
//       child: Chip(
//         backgroundColor: Style.randomColor[index],
//         // avatar: CircleAvatar(
//         //   child: Icon(
//         //     Icons.adb,
//         //   ),
//         // ),
//         deleteIcon: Icon(
//           Icons.check,
//         ),
//         // onDeleted: () {
//         //   print("item deleted");
//         // },
//         label: Text(
//           name,
//           style: TextStyle(
//               // color: Style,
//               ),
//         ),
//       ),
//     );
//   }

//   Widget chipsHere() {
//     int index = -1;
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 10,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: name.map((val) {
//           index++;
//           return chipSelect(name[index], index);
//         }).toList(),
//       ),
//     );
//   }

//   showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AnimatedPadding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom - 1 > 0
//                 ? MediaQuery.of(context).viewInsets.bottom - 1
//                 : MediaQuery.of(context).viewInsets.bottom,
//           ),
//           duration: const Duration(milliseconds: 100),
//           reverseDuration: const Duration(milliseconds: 100),
//           curve: Curves.decelerate,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 // leading: Icon(
//                 //   Icons.image,
//                 // ),
//                 title: TextField(
//                   autofocus: true,
//                   controller: _eventController,
//                   decoration: InputDecoration(
//                     hintText: "What would you like to do?",
//                     // hintStyle: TextStyle(color: Colors.grey)
//                   ),
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//                 trailing: SendPageButton(
//                   dateSelected: dateSelected,
//                   notify: notify,
//                   type: type,
//                 ),

//                 // onTap: () => getImageGallery(context),
//               ),
//               chipsHere(),
//               // ListTile(
//               //   // leading: Icon(Icons.hi/),
//               //   title: chipsHere(),
//               //   // onTap: () => getImage(context),
//               // ),
//             ],
//           ),
//         );
//       });
// }

// class SendPageButton extends StatefulWidget {
//   DateTime dateSelected;
//   dynamic notify;
//   String type;
//   SendPageButton({
//     @required this.dateSelected,
//     @required this.notify,
//     @required this.type,
//   });
//   @override
//   _SendPageButtonState createState() => _SendPageButtonState();
// }

// bool _sendAvailable = false;

// class _SendPageButtonState extends State<SendPageButton> {
//   checkSend() {
//     _eventController.addListener(() {
//       setState(() {
//         _sendAvailable = _eventController.text.length > 0;
//       });
//     });
//   }

//   refresh() {
//     setState(() {});
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkSend();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // checkSend();
//     return Container(
//       child: IconButton(
//         onPressed: !_sendAvailable
//             ? null
//             : () {
//                 print("item added in user profile");
//                 setState(() {
//                   _sendAvailable = false;
//                 });
//                 _handleSubmit(
//                   context,
//                   widget.dateSelected,
//                   refresh,
//                   widget.notify,
//                   widget.type,
//                 );
//               },
//         icon: Icon(
//           Icons.send,
//           color: !_sendAvailable ? Colors.grey : Style.sendColor,
//         ),
//       ),
//     );
//   }
// }
