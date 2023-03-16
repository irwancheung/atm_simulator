import 'package:atm_simulator/export.dart';

class AppText {
  Text header(
    String text, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20.sp,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  Text body(
    String text, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  Text caption(
    String text, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  Text label(
    String text, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
