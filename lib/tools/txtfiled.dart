import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class custfiled extends StatelessWidget {
  custfiled(
      {super.key,
      this.hint,
      this.onsaved,
      this.hh,
      this.val,
      this.zz,
      this.jj,
      this.onfiledsubmited,
      this.len});
  TextEditingController? jj;
  String? Function(String?)? val;
  String? hint;
  int? len;
  void Function(String)? onfiledsubmited;
  void Function(String)? onsaved;
  List<TextInputFormatter>? hh;
  bool? zz;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        autofocus: true,
        maxLength: len ?? 60,
        onFieldSubmitted: onfiledsubmited,
        controller: jj,
        onChanged: onsaved,
        obscureText: zz ?? false,
        inputFormatters: hh,
        validator: val,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12)),
          hintText: hint ?? '',
        ),
      ),
    );
  }
}
