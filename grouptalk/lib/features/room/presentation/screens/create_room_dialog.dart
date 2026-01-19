import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouptalk/features/room/presentation/bloc/room_bloc.dart';

class CreateRoomDialog extends StatefulWidget {
  const CreateRoomDialog({super.key});

  @override
  State<CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  // Variable to track which privacy option is selected
  // true = Public, false = Private
  bool isPublic = true;
  final nameCtrl = TextEditingController();
  final subjectCtr = TextEditingController();
  final descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomCreated) {
          Navigator.pop(context);
          context.read<RoomBloc>().add(LoadJoinedRooms());
        }
      },

      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ), // Rounded corners
        child: Container(
          padding: const EdgeInsets.all(20),
          // SingleChildScrollView prevents overflow if the keyboard pops up
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Shrink to fit content height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Title + Close Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Create Study Room",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () =>
                          Navigator.pop(context), // Closes the dialog
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Form Fields
                _buildLabel("Room Name"),
                _buildTextField(hint: "e.g., Calculus Study Group", controller: nameCtrl),

                const SizedBox(height: 16),

                _buildLabel("Subject"),
                _buildTextField(hint: "e.g., Mathematics", controller: subjectCtr),

                const SizedBox(height: 16),

                _buildLabel("Description"),
                _buildTextField(
                  hint: "What will you study in this room?",
                  controller: descCtrl,
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                // 3. Privacy Toggle
                _buildLabel("Room Privacy"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildPrivacyButton("Public", true)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildPrivacyButton("Private", false)),
                  ],
                ),

                const SizedBox(height: 25),

                // 4. Create Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<RoomBloc>().add(
                        CreateRoomEvent(
                          name: nameCtrl.text.trim(),
                          subject: subjectCtr.text.trim(),
                          description: descCtrl.text.trim(),
                          isPublic: isPublic,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009688), // Teal color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Create Room",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for Labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
        ),
      ),
    );
  }

  // Helper widget for Text Inputs
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF009688), width: 2),
        ),
      ),
    );
  }

  // Helper widget for the Privacy Toggle Buttons
  Widget _buildPrivacyButton(String label, bool isOptionPublic) {
    // Check if this specific button is currently selected
    bool isSelected = isPublic == isOptionPublic;

    return GestureDetector(
      onTap: () {
        setState(() {
          isPublic = isOptionPublic;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
