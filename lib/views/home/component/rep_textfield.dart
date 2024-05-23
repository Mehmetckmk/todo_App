import 'package:flutter/material.dart';

import '../../../utils/app_str.dart';

class RepTextField extends StatelessWidget {
  const RepTextField({
    super.key,
    required this.controller,
    this.isForDescription=false,
    required this.onfieldSubmitted,
    required this.onChanged,
  });

  final TextEditingController? controller;
  final Function(String)? onfieldSubmitted;
  final Function(String)? onChanged;
  final bool isForDescription;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: TextFormField(
          controller: controller,
          maxLines:!isForDescription ?6:null,
          cursorHeight:!isForDescription ? 60:null,
          style:  TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: isForDescription ? InputBorder.none:null,
            counter: Container(),
            hintText: isForDescription ? AppStr.addNote:null,
            prefixIcon: isForDescription ?const Icon(Icons.bookmark_border,color: Colors.grey,):null,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey.shade300
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
          onFieldSubmitted: onfieldSubmitted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}