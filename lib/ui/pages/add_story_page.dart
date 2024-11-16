import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/provider/add_story_provider.dart';
import 'package:submission_story_app/shared/widgets/custom_button.dart';
import 'package:submission_story_app/shared/widgets/custom_text_field.dart';
import 'package:submission_story_app/shared/widgets/gap.dart';
import 'package:submission_story_app/utils/custom_snack_bar.dart';
import 'package:submission_story_app/utils/image_picker.dart';

class AddStoryPage extends StatefulWidget {
  final VoidCallback onPostStory;
  const AddStoryPage({super.key, required this.onPostStory});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? photo;
  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffE0E5E5),
      appBar: AppBar(
        title: const Text("Add Story"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Consumer<AddStoryProvider>(
          builder: (context, addPostProvider, _) {
            addPostProvider.responseState;

            if (addPostProvider.responseState == ResponseState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomButton().filledButton(widthScreen, "Post Story",
                () async {
              final description = _descriptionController.text.trim();
              if (formKey.currentState!.validate()) {
                /// create a new story
                /// The latitude and longitude are currently unavailable (null),
                /// but they can be filled in and used later.
                await Provider.of<AddStoryProvider>(context, listen: false)
                    .addStory(description, photo!, 0, 0);
                if (addPostProvider.responseState == ResponseState.success) {
                  if (context.mounted) {
                    widget.onPostStory();
                    CustomSnackBar()
                        .showSnackBar(context, addPostProvider.message, true);
                  }
                } else {
                  if (context.mounted) {
                    CustomSnackBar()
                        .showSnackBar(context, addPostProvider.message, false);
                  }
                }
              }
            });
          },
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  width: widthScreen,
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: photo == null
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  useSafeArea: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Wrap(
                                        runSpacing: 16,
                                        children: [
                                          Text("Please choose the image source",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall),
                                          CustomButton().filledButton(
                                              widthScreen, "From Camera",
                                              () async {
                                            pickedImage =
                                                await ImagePickerUtil()
                                                    .imagePickerFromCamera(
                                                        context);
                                            if (pickedImage != null) {
                                              setState(() {
                                                photo = pickedImage;
                                              });
                                            }
                                          }),
                                          CustomButton().outlinedButton(
                                              widthScreen, "Pick From Gallery",
                                              () async {
                                            pickedImage =
                                                await ImagePickerUtil()
                                                    .pickImageFromGallery(
                                                        context);
                                            if (pickedImage != null) {
                                              setState(() {
                                                photo = pickedImage;
                                              });
                                            }
                                          }),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_rounded),
                                Text("Import image"),
                              ],
                            ),
                          ),
                        )
                      : Image.file(
                          photo!,
                          width: widthScreen,
                          fit: BoxFit.cover,
                        ),
                ),
                const Gap.v(h: 16),
                Container(
                    height: 150,
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    child: CustomTextField(
                      label: "Description",
                      controller: _descriptionController,
                      textInputType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      validator: (value) {
                        if (value == '') {
                          return "Please enter your description";
                        }
                        return null;
                      },
                    ))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
