import 'package:flutter/material.dart';

errorDialog(
  BuildContext context,
  String title,
  String message,
) {
  return showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

// confirmDialog(
//   BuildContext context,
//   String title,
//   String message,
//   TextEditingController controller,
//   double totalPrice,
//   String address,
//   CustomerProfile profile,
//   OrderInfo orderInfo,
//   bool schedule,
// ) {
//   return showDialog(
//       context: context,
//       // barrierDismissible: false, 
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             title,
//             // textAlign: TextAlign.center,
//           ),
//           content: Text(
//             message + ": " + controller.text.toUpperCase(),
//             textAlign: TextAlign.center,
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             FlatButton(
//               child: Text("Proceed"),
//               onPressed: () {
//                 controller.clear();
//                 Navigator.pop(context);
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => AddressChange(
//                           totalPrice: totalPrice,
//                           address: address,
//                           orderInfo: orderInfo,
//                           promoCode: controller.text,
//                           profile: profile,
//                           schedule: schedule,
//                         ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       });
// }
