import 'package:flutter/material.dart';
import 'package:flutter_riverpod_blog_start/core/utils/validator_util.dart';
import 'package:flutter_riverpod_blog_start/model/post/post.dart';
import 'package:flutter_riverpod_blog_start/view/components/custom_elevated_button.dart';
import 'package:flutter_riverpod_blog_start/view/components/custom_text_form_field.dart';
import 'package:flutter_riverpod_blog_start/view/components/custom_textarea.dart';
import 'package:flutter_riverpod_blog_start/view/pages/post/update_page/components/post_update_form.dart';

class PostUpdateBody extends StatelessWidget {
  final Post post;
  PostUpdateBody(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PostUpdateForm(post),
    );
  }
}
