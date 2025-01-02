import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_form_field_dynamic/features/registraction_form/bloc/registration_bloc.dart';
import 'package:text_form_field_dynamic/features/registraction_form/bloc/registration_event.dart';
import 'package:text_form_field_dynamic/features/registraction_form/bloc/registration_state.dart';


class DynamicRegistrationScreen extends StatelessWidget {
  const DynamicRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
  builder: (context, state) {
    return DynamicRegistrationWidget();
  },
);
  }
}


class DynamicRegistrationWidget extends StatefulWidget {
  const DynamicRegistrationWidget({super.key});

  @override
  State<DynamicRegistrationWidget> createState() =>
      _DynamicRegistrationWidgetState();
}

class _DynamicRegistrationWidgetState extends State<DynamicRegistrationWidget> {
  // GlobalKey to manage form state and validation
  final _formKey = GlobalKey<FormState>();

  // ScrollController for scrolling to the invalid field
  final ScrollController _scrollController = ScrollController();

  // List of GlobalKeys to manage each field's state
  List<GlobalKey<FormFieldState>> _fieldKeys = [];

  // List of FocusNodes to manage focus on each field
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    // Initializing dynamic field creation
    context.read<RegistrationBloc>().add(AddFieldEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Create a FocusNode for each field
    FocusNode focusNode = FocusNode();
    _focusNodes.add(focusNode);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Registration Fields with BLoC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            if (state is RegistrationInitialState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is RegistrationFieldsState) {
              // Update the list of field keys and focus nodes based on the number of controllers
              _fieldKeys = List.generate(
                  state.controllers.length, (index) => GlobalKey<FormFieldState>());
              _focusNodes = List.generate(
                  state.controllers.length, (index) => FocusNode());

              return Form(
                key: _formKey, // Assign the global key here
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  margin: EdgeInsets.all(5),
                  child: ListView.builder(
                    controller: _scrollController, // Controller for scrolling
                    itemCount: state.controllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: state.controllers[index],
                                key: _fieldKeys[index], // Assign GlobalKey here
                                focusNode: _focusNodes[index], // Assign FocusNode here
                                decoration: InputDecoration(
                                  labelText: 'Field ${index + 1}',
                                  border: OutlineInputBorder(),
                                ),
                                // Validator to check if the field is empty
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                BlocProvider.of<RegistrationBloc>(context)
                                    .add(RemoveFieldEvent(index));
                                // Remove the corresponding GlobalKey and FocusNode when a field is removed
                                _fieldKeys.removeAt(index);
                                _focusNodes.removeAt(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new field when button is clicked
          BlocProvider.of<RegistrationBloc>(context).add(AddFieldEvent());
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // Validate the form
          if (_formKey.currentState?.validate() ?? false) {
            // If form is valid, submit it
            BlocProvider.of<RegistrationBloc>(context)
                .add(SubmitRegistrationEvent());
          } else {
            // If form is invalid, scroll to the first invalid field
            _scrollToFirstInvalidField();
          }
        },
        child: Text('Submit'),
      ),
    );
  }

  // Method to scroll to the first invalid field and set focus on it
  void _scrollToFirstInvalidField() {
    final formState = _formKey.currentState;
    if (formState != null) {
      for (int index = 0; index < _fieldKeys.length; index++) {
        final focusNode = _focusNodes[index];
        // Check if the field at the current index is invalid
        final fieldState =  _fieldKeys[index].currentState!.validate();
        print("sdjskdh ${fieldState}");

      }
    }
  }
}
