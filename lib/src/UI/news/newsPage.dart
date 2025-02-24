import 'package:cached_network_image/cached_network_image.dart';
import 'package:calender_app/src/UI/news/newsList.dart';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/resources/newsApi.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

class NewsPage extends StatelessWidget {
  final dynamic data;
  NewsPage({@required this.data});
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Card(
        color: c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: c.cWidth,
              // color: Colors.red,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
              child: Text(
                'TOP NEWS',
                textAlign: TextAlign.left,
                style: TextStyle(
                  // fontSize: 16,
                  color: c.theme == 1
                      ? Style.primaryColor
                      : Style.invertPrimaryColor,
                ),
              ),
            ),
            buildBottomData(
              context,
              orientation,
              data,
              0,
            ),
            Divider(
              height: 0,
              color: c.theme == 1 ? Style.greyColor : Style.invertGreyColor,
            ),
            viewAll(context),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(
    Orientation orientation,
  ) {
    return FutureBuilder(
        future: getNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return error();
            }
            print("snapshot data here ${snapshot.data}");
            if (snapshot.data == false) return error();
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: buildBottomData(
                context,
                orientation,
                snapshot.data,
                0,
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget error() {
    return Container(
      child: Text(
        "Some error occured",
      ),
    );
  }

  Widget buildBottomData(
    BuildContext context,
    Orientation orientation,
    dynamic data,
    int index,
  ) {
    String date = DateTime.now().toString();
    DateTime d;
    DateTime current;
    Duration diff = Duration(microseconds: 0);
    var imgData;
    if (data != null) {
      if (data["articles"] != null) {
        date =
            data["articles"][index]["publishedAt"].toString().substring(0, 19);
      }

      d = DateTime.parse(date);
      current = DateTime.now();
      diff = current.difference(d);
      date = timeago.format(current.subtract(diff));
      imgData = data["articles"][index]["urlToImage"];
      if (imgData != null) data["articles"][index]["urlToImage"] = imgData;
    } else
      return Container();
    String url = data["articles"][index]["url"];

    return Container(

                  // width: c.cWidth * 0.4,
                  // height: c.cHeight * 0.15,
      // color: Colors.red,
      child: InkWell(
        onTap: () => goToUrl(url),
        // onTap: () => Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => NewsList(
        //       data: data,
        //     ),
        //   ),
        // ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 22,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: c.cWidth * 0.4,
                  height: c.cHeight * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: imgData == null
                      ? Container()
                      : CachedNetworkImage(
                          // placeholder: (context, url) =>
                          //     // Image.asset(
                          //     //   "assets/searching.gif",
                          //     // ),
                          //     CircularProgressIndicator(),
                          fadeInDuration: Duration(
                            seconds: 3,
                          ),
                          imageUrl: imgData,
                          fit: BoxFit.cover,
                          width: 160,
                          height: 110,
                        ),
                ),
              ),
              Expanded(
                child: Container(
                  // color: Colors.yellow,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  // width: c.cWidth * 0.4,
                  // height: c.cHeight * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            data == null
                                ? ""
                                : data["articles"][index]["title"],
                            textAlign: TextAlign.left,
                            maxLines:
                                orientation == Orientation.landscape ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: c.theme == 1
                                  ? Style.primaryColor
                                  : Style.invertPrimaryColor,
                            ),
                          ),

                          // Text("[Read more...]"),

                          Padding(
                            padding: EdgeInsets.only(top: 8),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data["articles"][index]["source"]["name"] ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                // fontSize: 15,
                                // fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.update,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              8,
                            ),
                          ),
                          Text(
                            date ?? "",
                            style: TextStyle(
                              color: Colors.grey,
                              // fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget viewAll(
    BuildContext context,
  ) {
    return Container(
      width: c.cWidth,
      height: 55,
      child: RaisedButton(
        color: c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
        onPressed: () {
          print("go to EventListPage");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewsList(
                data: data,
              ),
            ),
          );
        },
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        child: Text(
          "View All",
          textAlign: TextAlign.left,
          style: TextStyle(
            // fontSize: 16,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
