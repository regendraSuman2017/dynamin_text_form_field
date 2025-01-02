import 'package:flutter/material.dart';

abstract class RegistrationState {}

class RegistrationInitialState extends RegistrationState {}

class RegistrationFieldsState extends RegistrationState {
  final List<TextEditingController> controllers;

  RegistrationFieldsState({required this.controllers});
}

class RegistrationSubmissionState extends RegistrationState {
  final String message;

  RegistrationSubmissionState({required this.message});
}
