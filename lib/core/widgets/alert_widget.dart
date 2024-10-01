
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../../data/providers/menu_provider.dart';
import '../../themes/color_palette.dart';
import '../constants/constants.dart';

class MyDialog extends StatelessWidget {

  final String title;
  final String content;
  final String nameYes;
  final String nameNo;
  final VoidCallback ok;

  const MyDialog({
    required this.title,
    required this.content,
    required this.nameYes,
    required this.nameNo,
    required this.ok,

    super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
        backgroundColor: theme.cardColor,
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: Constants.kDefaultPadding / 2),
              Text(title,
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
                content,
                style: theme.textTheme.bodyMedium,
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
                        onPressed: ok,
                        icon: const Icon( FeatherIcons.check, color:Colors.white, size: 16,),
                        label:Text(
                          nameYes,
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
                          nameNo,
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}


class MyLogoutDialog extends StatelessWidget {

  final String title;
  final String content;
  final String nameYes;
  final String nameNo;
  final VoidCallback ok;

  const MyLogoutDialog({
    required this.title,
    required this.content,
    required this.nameYes,
    required this.nameNo,
    required this.ok,

    super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
        backgroundColor: theme.cardColor,
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: Constants.kDefaultPadding / 2),
              Text(title,
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
                content,
                style: theme.textTheme.bodyMedium,
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
                        onPressed: ok,
                        icon: const Icon( FeatherIcons.check, color:Colors.white, size: 16,),
                        label:Text(
                            nameYes,
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
                          final menuProvider = Provider.of<MenuProvider>(context, listen: false);
                          menuProvider.resetSelection();
                        },
                        icon: const Icon( FeatherIcons.x, color:Colors.white, size: 16,),
                        label: Text(
                          nameNo,
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}