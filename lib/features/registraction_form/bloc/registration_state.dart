import 'package:flutter/material.dart';

abstract class RegistrationState {}

class RegistrationInitialState extends RegistrationState {}

class RegistrationFieldsState extends RegistrationState {
  final List<TextEditingController> controllers;
 final int controllerLength;

  RegistrationFieldsState({required this.controllers,required this.controllerLength});
}

class RegistrationSubmissionState extends RegistrationState {
  final String message;

  RegistrationSubmissionState({required this.message});
}
