import 'dart:io';
import 'dart:typed_data';
import 'package:connect_if/features/auth/presentation/components/my_text_field.dart';
import 'package:connect_if/features/post/domain/entities/post.dart';
import 'package:connect_if/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect_if/features/post/presentation/cubits/posts_states.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:connect_if/features/auth/domain/entities/app_user.dart';
import 'package:connect_if/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile image pick
  PlatformFile? imagePickedFile;

  // web image pick
  Uint8List? webImage;

  // text constroller -> caption
  final textController = TextEditingController();

  // current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // create & upload post
  void uploadPost() {
    // check if both image and caption are provided
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insira a imagem e a legenda'),
        ),
      );
      return;
    }

    // create a new post object
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // post cubit
    final postCubit = context.read<PostCubit>();

    // web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }

    // mobile upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BLOC CONSUMER => builder + listener
    return BlocConsumer<PostCubit, PostStates>(
      builder: (context, state) {
        // loading or uploading...
        if (state is PostsLoading || state is PostUploading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // build upload page
        return buildUploadPage();
      }, 
      // go to the previous page when upload is done & posts are loaded
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      }
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text("Criar post"),
        foregroundColor: AppThemeCustom.blue800,
        actions: [
          // upload button
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.upload),
          ),
        ],
      ),

      // BODY
      body: Center(
        child: Column(
          children: [
        // image preview for web
        if (kIsWeb && imagePickedFile != null)
          Image.file(File(imagePickedFile!.path!)),

        const SizedBox(height: 20),

        // pick image button
        MaterialButton(
          onPressed: pickImage,
          color: AppThemeCustom.green500,
          child: const Text("Escolher imagem", style: TextStyle(color: AppThemeCustom.black)),
        ),

        const SizedBox(height: 20),

        // caption text box
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: MyTextField(
          controller: textController, 
          hintText: "Descrição", 
          obscureText: false,
          ),
        )
          ],
        ),
      ),
    );
  }
}