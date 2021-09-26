import 'package:intl/intl.dart';

class TimeConverter {

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var dayFormat = DateFormat('HH:mm a');
    var monthFormat = DateFormat('MMM dd, HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0) {
      //time = format.format(date);
      time = 'now';
    }else if(diff.inSeconds > 0 && diff.inMinutes == 0) {
      time = diff.inSeconds.toString() + ' s';
    } else if(diff.inMinutes > 0 && diff.inHours == 0) {
      time = diff.inMinutes.toString() + ' min';
    } else if(diff.inHours > 0 && diff.inDays == 0) {
      time = diff.inHours.toString() + ' h';
    }
    else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays < 2) {
        time = diff.inDays.toString() + ' day ago';
      } else {
        time = diff.inDays.toString() + ' days ago, ${dayFormat.format(date)}';
      }
    }else if((diff.inDays/7) > 4 )
    {
      time = monthFormat.format(date);
    }
    else {
      if (diff.inDays < 14) {
        time = (diff.inDays / 7).floor().toString() + ' week ago';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' weeks ago';
      }
    }

    return monthFormat.format(date);//time;
  }

  String getDuration(int timestamp, int period) {

    var publishDate = DateTime.fromMillisecondsSinceEpoch(timestamp);

    var expiryDate = DateTime.fromMillisecondsSinceEpoch(timestamp+period);

    String time = '';

    var diff = expiryDate.difference(publishDate);

    if(diff.inSeconds > 0 && diff.inMinutes == 0) {
      time = diff.inSeconds.toString() + ' seconds';
    } else if(diff.inMinutes > 0 && diff.inHours == 0) {
      time = diff.inMinutes.toString() + ' minutes';
    } else if(diff.inHours > 0 && diff.inDays == 0) {
      time = diff.inHours.toString() + ' hours';
    }else if(diff.inDays > 0) {
      time = diff.inDays.toString() + " days";
    }

    return time;
  }

}