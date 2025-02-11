import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AcknowledgmentService {
  static const Map<String, int> acknowledgmentScores = {
    'Not Understood': 0,
    'Partially Understood': 1,
    'Understood': 2,
    'Well Understood': 3,
    'Fully Understood': 4,
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
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: ElevatedButton(
        onPressed: () async {
          final result = await showAcknowledgmentDialog(context);
          if (result != null) {
            await onAcknowledge(result['acknowledgement'], result['score']);
          } else if (onNext != null && isAcknowledgementSelected) {
            onNext();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedAcknowledgement,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined,
                        color: secondaryColor),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: GestureDetector(
                  onTap: isAcknowledgementSelected ? onNext : null,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isAcknowledgementSelected
                          ? secondaryColor
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
