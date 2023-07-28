import 'package:flutter/material.dart';

@immutable
class SummarizeModel {
  final String id;
  final String message;
  final bool isMe;

  const SummarizeModel({
    required this.id,
    required this.message,
    required this.isMe,
  });
}
