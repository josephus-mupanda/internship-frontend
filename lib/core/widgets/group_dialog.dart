
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../themes/color_palette.dart';
import '../constants/constants.dart';
import 'input_widget.dart';

class GroupDialog extends StatefulWidget {

  final String title;
  final String content;
  final String nameYes;
  final String nameNo;

  const GroupDialog({
    required this.title,
    required this.content,
    required this.nameYes,
    required this.nameNo,
    super.key});

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? name, description;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
        backgroundColor: theme.cardColor,
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: Constants.kDefaultPadding / 2),
              Text( widget.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.content,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(
                height: Constants.kDefaultPadding/2,
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputWidget(
                      obscureText: false,
                      hintText: 'Enter Group Name',
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.group,
                      onChanged: (String? value) => name = value!,
                      validator: (String? value) => value!.isEmpty ? "Group name is required" : null,
                    ),
                    InputWidget(
                      obscureText: false,
                      hintText: 'Enter Group Description',
                      maxLines: 3,
                      prefixIcon: Icons.description,
                      onChanged: (String? value) => description = value!,
                      validator: (String? value) => value!.isEmpty ? "Description is required" : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Constants.kDefaultPadding/2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child:  TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: ColorPalette.primaryColor,
                          //foregroundColor: kTextColor, // Set the text color here
                        ),
                        onPressed:() {
                          if (formKey.currentState?.validate() ?? false) {
                            formKey.currentState?.reset();
                            setState(() {
                              name = null;
                              description = null;
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon( FeatherIcons.check, color:Colors.white, size: 16,),
                        label:Text(
                            widget.nameYes,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white
                            )
                        ),
                      )
                  ),
                  const SizedBox(
                    width: Constants.kDefaultPadding/2,
                  ),
                  Expanded(
                      child:  TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: theme.colorScheme.background,
                          // foregroundColor: kTextColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon( FeatherIcons.x, color:Colors.white, size: 16,),
                        label: Text(
                          widget.nameNo,
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                  ),
                ],
              )
            ],
          ),
        ),
    );
  }
}