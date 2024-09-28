import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServerWrapperState {
  final int id;
  final List<int> timeLine = [];

  ServerWrapperState({required this.id});
}
