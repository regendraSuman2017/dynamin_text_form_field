

abstract class RegistrationEvent {}

class AddFieldEvent extends RegistrationEvent {}

class RemoveFieldEvent extends RegistrationEvent {
  final int index;

  RemoveFieldEvent(this.index);
}

class SubmitRegistrationEvent extends RegistrationEvent {}
