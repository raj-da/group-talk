import 'package:flutter/material.dart';
import 'package:grouptalk/features/room/presentation/screens/create_room_dialog.dart';
import 'package:grouptalk/features/room/presentation/widgets/build_button.dart';

Widget actionButton(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: buildButton(Icons.add, "Create Room", () {
          showDialog(
            context: context,
            builder: (context) => const CreateRoomDialog(),
          );
        }),
      ),
      const SizedBox(width: 15), // Spacing between buttons
      Expanded(child: buildButton(Icons.book_outlined, "Flashcards", () {})),
    ],
  );
}
