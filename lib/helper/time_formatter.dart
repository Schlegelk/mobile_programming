/*
  TIMESTAMP
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
}
