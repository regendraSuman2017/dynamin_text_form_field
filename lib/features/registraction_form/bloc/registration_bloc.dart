import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:text_form_field_dynamic/features/registraction_form/bloc/registration_event.dart';
import 'package:text_form_field_dynamic/features/registraction_form/bloc/registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitialState()) {

    on<AddFieldEvent>(_onAddFieldEvent);
    on<RemoveFieldEvent>(_onRemoveFieldEvent);
    // Handler for SubmitRegistrationEvent
    on<SubmitRegistrationEvent>((event, emit) {
      if (state is RegistrationFieldsState) {
        final controllers = (state as RegistrationFieldsState).controllers;
        String result = '';
        for (int i = 0; i < controllers.length; i++) {
          result += 'Field ${i + 1}: ${controllers[i].text}\n';
        }

        emit(RegistrationSubmissionState(message: result));
      }
    });
  }

  _onAddFieldEvent(event, emit) {
    if (state is RegistrationFieldsState) {
      if((state as RegistrationFieldsState).controllers.length<4) {
        final List<TextEditingController> newControllers = List<TextEditingController>.from(
          (state as RegistrationFieldsState).controllers,
        )..add(TextEditingController());

        emit(RegistrationFieldsState(controllers: newControllers,controllerLength: (state as RegistrationFieldsState).controllers.length+1));
      }else{
        if (kDebugMode) {
          print("More then 4");
        }
      }

    } else {
      emit(RegistrationFieldsState(controllers: [TextEditingController()],controllerLength: 2));
    }
  }


  // Handler for RemoveFieldEvent
  _onRemoveFieldEvent<RemoveFieldEvent>(event, emit) {
  if (state is RegistrationFieldsState) {
  final newControllers = List<TextEditingController>.from(
  (state as RegistrationFieldsState).controllers,
  )..removeAt(event.index);

  emit(RegistrationFieldsState(controllers: newControllers,controllerLength: (state as RegistrationFieldsState).controllers.length+1));
  }
  }

}
