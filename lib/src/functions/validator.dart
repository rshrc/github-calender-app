dynamic validatePhone(
  String value,
) {
  if (value.length < 10) {
    return 'Enter a valid Phone Number,';
  } // final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
  // if (!nameExp.hasMatch(value))
  //   return 'Please enter only alphabetical character.';
}

// dynamic validateAadhar(
//   String value,
// ) {
//   if (value.length != 12) {
//     return 'Enter a valid Aadhar Number,';
//   }
// }

// dynamic validateCAccount(
//   String value,
//   String accountNumber,
// ) {
//   print("value $value");
//   print("accountNumber $accountNumber");
//   if (value != accountNumber.toString()) {
//     return "Account Number does not match";
//   }
// }

dynamic validateEmail(
  String email,
) {
  // String email = val;
  if (email == "") return null;
  bool emailValid =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  if (emailValid) {
    return null;
  }
  return "Enter a valid email address";
}
