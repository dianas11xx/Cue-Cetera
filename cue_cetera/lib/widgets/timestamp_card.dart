import 'package:flutter/material.dart';
import 'package:cue_cetera/classes/timestamp.dart';
import 'package:cue_cetera/services/user_settings.dart';

class TimestampCard extends StatelessWidget {

  final Timestamp timestamp;
  final Function jump;

  // there is probably a way to not define these sets twice
  List<int> positiveEmotions = [2, 4];

  List<int> negativeEmotions = [0, 1, 3];

  // dont actually need this list with current implementation, but makes it clear
  List<int> neutralEmotions = [5];

  TimestampCard({required this.timestamp, required this.jump});

  String getEmotion(int emotion) {
    switch(emotion) {
      case 0:
        return "Angry";
      case 1:
        return "Fearful";
      case 2:
        return "Happy";
      case 3:
        return "Sad";
      case 4:
        return "Surprised";
      case 5:
        return "Neutral";
      default: // we ideally never want this to happen
        print("Invalid emotion value");
        return "Neutral";
    }
  }

  // there is probably a way to not have to write this function twice
  String getEmotionImagePath(int emotion) {
    String thumbString = "";
    if (positiveEmotions.contains(emotion)) {
      thumbString = "greenThumb";
      if(UserSettings.colorBlind){
        thumbString = "blueThumb";
      }
    }
    else if (negativeEmotions.contains(emotion)) {
      thumbString = "redThumb";
    }
    else {
      thumbString = "neutralThumb";
    }

    // use the three block if/else using three dictionaries
    return "assets/imgs/thumbs/$thumbString.png";
  }

  String formatTime(int timeMs) {
    // we have our time in milliseconds, but we want to translate this to XX:XX
    // first the first XX is minutes and the second XX is seconds. First we find
    // seconds. we can use integer division, this is only for display
    int totalSeconds = timeMs ~/ 1000; // the tilde is used for integer division in dart:
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minutesString = minutes < 10 ? "0$minutes" : "$minutes";
    String secondsString = seconds < 10 ? "0$seconds" : "$seconds";
    return "$minutesString:$secondsString";
  }

  int getBackgroundColor(int emotion) {

    if (positiveEmotions.contains(emotion)) {
      if(UserSettings.colorBlind){
        return 0xffb3d4ff; // blue
      }
      return 0xffb9FE19F; //light green
    }
    else if (negativeEmotions.contains(emotion)) {
        return 0xffffb3b3; // red
    }
    else {
      return 0xff808080; // gray
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => jump(timestamp.timeMs),
        //title: Text("${timestamp.timeMs}"),
        title: Text(
          formatTime(timestamp.timeMs!),
          style: const TextStyle(
            //fontWeight: FontWeight.bold,
            fontFamily: "Lusteria",
          ),
        ),
        tileColor: Color(getBackgroundColor(timestamp.emotion!)),
        visualDensity: const VisualDensity(vertical: 4),
        leading: CircleAvatar(
          backgroundImage: AssetImage(getEmotionImagePath(timestamp.emotion!)),
          backgroundColor: Color(getBackgroundColor(timestamp.emotion!)),
          radius: 25,
        ),
        trailing: Text(
          getEmotion(timestamp.emotion!),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Lusteria",
            //letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
