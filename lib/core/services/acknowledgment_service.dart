import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AcknowledgmentService {
  static const Map<String, int> acknowledgmentScores = {
    'Done': 1,
    'Not Done': 0,
  };

  static Future<Map<String, dynamic>?> showAcknowledgmentDialog(
    context,
  ) async {
    return await showCupertinoModalPopup<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Acknowledge Child\'s Understanding'),
        actions: acknowledgmentScores.entries.map((entry) {
          return CupertinoActionSheetAction(
            child: Text(entry.key),
            onPressed: () {
              Navigator.pop(context, {
                'acknowledgement': entry.key,
                'score': entry.value,
              });
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  static Widget buildAcknowledgmentButton({
    required BuildContext context,
    required String selectedAcknowledgement,
    required Color secondaryColor,
    required VoidCallback? onNext,
    required Future<void> Function(String acknowledgement, int score)
        onAcknowledge,
  }) {
    bool isAcknowledgementSelected =
        selectedAcknowledgement != 'Acknowledgement';

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 20.0, top: 10, right: 20, left: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final result = await showAcknowledgmentDialog(context);
                if (result != null) {
                  await onAcknowledge(
                      result['acknowledgement'], result['score']);
                } else if (onNext != null && isAcknowledgementSelected) {
                  onNext();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedAcknowledgement,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.keyboard_arrow_down_outlined,
                        color: secondaryColor),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 6), // 2px space between buttons
          ElevatedButton(
            onPressed: isAcknowledgementSelected ? onNext : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Color.fromARGB(255, 111, 138,
                        220); // Still show the color even when disabled
                  }
                  return Color.fromARGB(255, 28, 75, 214); // Active state color
                },
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
              ),
            ),
            child: Text(
              "Next",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
