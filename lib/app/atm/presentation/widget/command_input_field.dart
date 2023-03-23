import 'package:atm_simulator/export.dart';
import 'package:google_fonts/google_fonts.dart';

class CommandInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  final void Function(String)? onSubmitted;

  const CommandInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        SafeArea(
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  maxLength: 50,
                  onSubmitted: onSubmitted,
                  style: TextStyle(
                    fontFamily: GoogleFonts.notoSans().fontFamily,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type your command here and press enter...',
                    hintStyle: TextStyle(
                      fontFamily: GoogleFonts.notoSans().fontFamily,
                      fontSize: 16.sp,
                    ),
                    prefix: text.body('\$   '),
                    border: InputBorder.none,
                    counterText: '',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
