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


  @override
  void initState() {
    super.initState();
    // Initializing dynamic field creation
    context.read<RegistrationBloc>().add(AddFieldEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Create a FocusNode for each field

    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Registration Fields with BLoC',style: TextStyle(fontSize: 14),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            if (state is RegistrationInitialState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is RegistrationFieldsState) {
              // Update the list of field keys and focus nodes based on the number of controllers
              _fieldKeys = List.generate(state.controllers.length, (index) => GlobalKey<FormFieldState>());
              return Column(
                children: [
                  Form(
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
                                  icon: Icon(Icons.delete_outline_sharp, color: Colors.red),
                                  onPressed: () {
                                    context.read<RegistrationBloc>().add(RemoveFieldEvent(index));
                                    // Remove the corresponding GlobalKey and FocusNode when a field is removed
                                    _fieldKeys.removeAt(index);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                ],
              );
            }
            return Container();
          },
        ),
      ),

      bottomNavigationBar: BlocBuilder<RegistrationBloc, RegistrationState>(
  builder: (context, state) {
    print("akskskj ${state}");
    if (state is RegistrationFieldsState) {
      print("akskskj ${state.controllerLength}");
      if(state.controllerLength<4)
      return Row(
        children: [
          Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey), // Fixed the backgroundColor declaration
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0)), // Add padding for better visual spacing
                  elevation: WidgetStateProperty.all<double>(5), // Add elevation for a shadow effect
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0), // Rounded corners
                    ),
                  ),
                  side: WidgetStateProperty.all<BorderSide>(BorderSide(color: Colors.blueGrey, width: 1)), // Optional: Border with color
                ),
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState?.validate() ?? false) {
                    // If form is valid, submit it
                    context.read<RegistrationBloc>().add(SubmitRegistrationEvent());
                  } else {
                    _scrollToFirstInvalidField();
                  }
                },
                child: Text(
                  'Submit Form',
                  style: TextStyle(
                    color: Colors.white, // Text color for better contrast
                    fontWeight: FontWeight.bold, // Bold text for emphasis
                    fontSize: 16.0, // Optional: Adjust font size
                  ),
                ),
              )

          ),
          SizedBox(width: 10,),



          Expanded(
              child:   ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.green), // Fixed the backgroundColor declaration
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0)), // Add padding for better visual spacing
                  elevation: WidgetStateProperty.all<double>(5), // Add elevation for a shadow effect
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0), // Rounded corners
                    ),
                  ),
                  side: WidgetStateProperty.all<BorderSide>(BorderSide(color: Colors.blueGrey, width: 1)), // Optional: Border with color
                ),
                onPressed: () {
                  // If form is valid, submit it
                  context.read<RegistrationBloc>().add(AddFieldEvent());
                },
                child: Text(
                  'Add More Field',
                  style: TextStyle(
                    color: Colors.white, // Text color for better contrast
                    fontWeight: FontWeight.bold, // Bold text for emphasis
                    fontSize: 16.0, // Optional: Adjust font size
                  ),
                ),
              )

          ),

        ],
      );
    }else {
      return Row(
        children: [
          Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey), // Fixed the backgroundColor declaration
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0)), // Add padding for better visual spacing
                  elevation: WidgetStateProperty.all<double>(5), // Add elevation for a shadow effect
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0), // Rounded corners
                    ),
                  ),
                  side: WidgetStateProperty.all<BorderSide>(BorderSide(color: Colors.blueGrey, width: 1)), // Optional: Border with color
                ),
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState?.validate() ?? false) {
                    // If form is valid, submit it
                    context.read<RegistrationBloc>().add(SubmitRegistrationEvent());
                  } else {
                    _scrollToFirstInvalidField();
                  }
                },
                child: Text(
                  'Submit Form',
                  style: TextStyle(
                    color: Colors.white, // Text color for better contrast
                    fontWeight: FontWeight.bold, // Bold text for emphasis
                    fontSize: 16.0, // Optional: Adjust font size
                  ),
                ),
              )

          ),
          SizedBox(width: 10,),


        ],
      );
    }
    return TextFormField();
  },
),
    );
  }

  // Method to scroll to the first invalid field and set focus on it
  void _scrollToFirstInvalidField() {
    final formState = _formKey.currentState;
    if (formState != null) {
      for (int index = 0; index < _fieldKeys.length; index++) {
        // final focusNode = _focusNodes[index];
        // Check if the field at the current index is invalid
        final fieldState =  _fieldKeys[index].currentState!.validate();
        print("sdjskdh ${fieldState}");

      }
    }
  }
}
