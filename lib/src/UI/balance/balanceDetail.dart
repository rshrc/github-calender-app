import 'dart:math';

import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:firebase_database/firebase_database.dart' as database;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../calender/calender1.dart' as calender;

class BalanceDetail extends StatefulWidget {
  int i;
  BalanceDetail({@required this.i});
  @override
  _BalanceDetailState createState() => _BalanceDetailState();
}

class _BalanceDetailState extends State<BalanceDetail> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  TextEditingController noteController = TextEditingController();
  // List<dynamic>
  String name;
  bool isExpanded = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name = calender.balanceKeysList[widget.i].toString();
  }

  bool initLoading = false;

  addData(
    BuildContext context2,
    String date,
  ) async {
    String uid = calender.uid;
    String path = 'user/$uid/balance/$name';

    print("name here is ------------------------------: $name");

    if (uid != null) {
      setState(() {
        initLoading = true;
      });
      try {
        var itemref =
            database.FirebaseDatabase.instance.reference().child(path);
        database.DataSnapshot response = await itemref.child(date).once();
        // print("response here is $response");
        // print("response value here is ${response.value.runtimeType}");
        // print("response key here is ${response.key}");
        List<dynamic> value = [];
        if (response.value != null) {
          value.addAll(response?.value);
        }
        Map<String, dynamic> unit = {
          'note': noteController.text,
        };
        // List<dynamic> value = response?.value;
        value.add(unit);

        Map<String, dynamic> data = {
          date: value,
        };

        await itemref.update(data).then((val) {
          // print(
          //     "balanceMap is ${calender.balanceMap[calender.balanceKeysList[widget.i]][date]}");
          bool exist = false;
          if (calender.balanceMap[calender.balanceKeysList[widget.i]] == null) {
            exist = false;
          } else
            exist = calender.balanceMap[calender.balanceKeysList[widget.i]]
                    ?.containsKey(date) ??
                false;
          if (exist) {
            // update.update(date, data);
            // print(
            //     "type check9999999999 ${calender.balanceMap[calender.balanceKeysList[widget.i]][date].runtimeType}");
            // calender.balanceMap[calender.balanceKeysList[widget.i]][date].add(data);
            var r = List<Map<dynamic, dynamic>>.from(
                calender.balanceMap[calender.balanceKeysList[widget.i]][date]);
            r.add(unit);

            calender.balanceMap[calender.balanceKeysList[widget.i]][date] = r;
            // print("r ggere is $r");
            // print("r ggere is ${r.runtimeType}");
          } else {
            calender.balanceMap[calender.balanceKeysList[widget.i]][date] = [
              unit,
            ];
          }
          // print(
          //     "balanceMap is ${calender.balanceMap[calender.balanceKeysList[widget.i]][date]}");
          setState(() {});
          // calender.balanceMap[calender.balanceKeysList[widget.i]].add(data);
        });

        setState(() {
          initLoading = false;
        });
      } catch (e) {
        setState(() {
          initLoading = false;
        });
        errorDialog(
          context,
          "Try Again",
          "Are you connected to internetil $e",
        );
      }
    } else {
      if (initLoading)
        setState(() {
          initLoading = false;
        });
    }
    noteController?.clear();
    Navigator.pop(context2);
  }

  addDialog(String date, String showDate) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: Border.all(style: BorderStyle.none),
        title: Text(
          "Add on $showDate",
        ),
        content: feild(),
        actions: <Widget>[
          CupertinoButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: CupertinoColors.activeBlue,
              ),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              print("save in on its way");

              return initLoading
                  ? null
                  : addData(
                      context,
                      date,
                    );
            },
            child: Text(
              "Add",
              style: TextStyle(
                color: CupertinoColors.activeGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget feild() {
    return Container(
      // width: cWidth * 0.5,
      child: TextFormField(
        controller: noteController,
        style: TextStyle(
            // color: type == 'From' ? Colors.grey : Colors.black,
            ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // int _len =
    //     calender.balanceMap[calender.balanceKeysList[widget.i]]?.length ?? 0;
    Map<dynamic, dynamic> here =
        calender.balanceMap[calender.balanceKeysList[widget.i]];

    Iterable<dynamic> keys = here?.keys;
    List<dynamic> keyList = keys?.toList();
    String title = calender.balanceKeysList[widget.i].toString();

    DateTime startDate = DateTime.parse(title.substring(0, 10));
    DateTime endDate = DateTime.parse(title.substring(14));

    String title1 = DateFormat.yMMMd().format(startDate);
    String title2 = DateFormat.yMMMd().format(endDate);

    String titleContent = title1 + '  to  ' + title2;
    // print("endDate here is $endDate");
    Duration d = endDate.difference(startDate);
    // print("Duration here is $d");
    String diff = d.toString();
    String check = diff.substring(0, diff.indexOf(':'));
    // print("check is $check");
    // print("diff is ${int.parse(check) / 24}");
    double dh = (int.parse(check) / 24);
    int _len = dh.floor() + 1;
    // List<List<dynamic>> childhere = List();
    // for (int i = 0; i < _len;i++){
    //   int j=
    // }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          c.theme == 0 ? Style.backgreyColor : Style.backInvertGreyColor,
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          // title,
          titleContent,
          style: TextStyle(
            fontSize: 20,
            color: Style.primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Style.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // actions: <Widget>[
        //   IconButton(
        //     onPressed: () {
        //       print('11111111111111111111111111111111 $isExpanded');
        //       setState(() {
        //         isExpanded = !isExpanded;
        //       });
        //     },
        //     icon: !isExpanded
        //         ? Icon(
        //             Icons.expand_more,
        //             color: Colors.white,
        //           )
        //         : Icon(
        //             Icons.expand_less,
        //             color: Colors.white,
        //           ),
        //     // Icon(
        //     //   Icons.expand_more,
        //     //   color: Colors.white,
        //     //   // size: 30,
        //     // ),
        //   )
        // ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _len,
          itemBuilder: (context, index) {
            // print("start date is $startDate");
            DateTime dateNow = startDate.add(Duration(days: index));
            String date = dateNow.toString().substring(0, 10);
            // print("length is: $_len");
            String showDate = DateFormat.yMMMd().format(dateNow);

            // print("here we have: ${here[keyList[index]][0]}");
            // print(
            //     "here we have: ${calender.balanceMap[calender.balanceKeysList[i]][index]}");
            bool exist = here.containsKey(date);
            List<dynamic> dHere = !exist ? List() : here[date];
            // print("here we have: ${here[date].runtimeType}");
            int indexHere = -1;
            List<Widget> childrenHere = !exist
                    ? [Container()]
                    : dHere.map((data) {
                        indexHere++;
                        // print("data here is ${data['note']}");
                        // print("index here is ${indexHere}");
                        return element(
                          data['note'] ?? 'null it is',
                          date.toString(),
                          indexHere,
                        );
                      }).toList()
                // +
                // [
                //   Container(
                //     child: TextFormField(
                //       controller: noteController,
                //     ),
                //   )
                // ]
                ;
            print("is Expanded here  is $isExpanded");
            return ExpansionTile(
              initiallyExpanded: isExpanded,
              leading: IconButton(
                onPressed: () {
                  // print("here we are adding $index");
                  return addDialog(
                    date,
                    showDate,
                  );
                },
                icon: Icon(Icons.add),
              ),
              title: Text(
                // date,
                showDate,
                // keyList[index],
                // 'title Here',
              ),
              children: childrenHere,
            );
          },
        ),
      ),
    );
  }

  Widget element(
    String value,
    String date,
    int index,
  ) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      // : DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      key: ObjectKey(value +
          (index + index * pow(10, index.toString().length)).toString()),
      child: elementShape(
        value,
      ),
      onDismissed: (direction) {
        if (calender.uid != null) {
          var itemRef = database.FirebaseDatabase.instance
              .reference()
              .child('user/${calender.uid}/balance/$name');

          List<dynamic> r = [];
          r.addAll(
              calender.balanceMap[calender.balanceKeysList[widget.i]][date]);
          r.removeAt(index);
          itemRef.update({date: r}).then((val) {
            print("value is udateing ");

            calender.balanceMap[calender.balanceKeysList[widget.i]][date] = r;
            refresh();
          });
          // calender.balanceKeysList.removeAt(index);
          // calender.balanceMap.remove(value);

        }
      },
    );
  }

  Widget elementShape(
    String value,
  ) {
    return Container(
      child: ListTile(
        leading: Icon(
          Icons.check_box_outline_blank,
          color: c.theme == 1 ? Style.primaryColor : Style.invertPrimaryColor,
        ),
        title: Text(
          value,
          style: TextStyle(
            color: c.theme == 1 ? Style.primaryColor : Style.invertPrimaryColor,
          ),
        ),
      ),
    );
  }
}
