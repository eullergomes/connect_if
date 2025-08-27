import 'dart:io';
import 'dart:typed_data';
import 'package:connect_if/features/services/auth/presentation/components/my_text_field.dart';
import 'package:connect_if/features/post/domain/entities/post.dart';
import 'package:connect_if/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect_if/features/post/presentation/cubits/posts_states.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:connect_if/features/services/auth/domain/entities/app_user.dart';
import 'package:connect_if/features/services/auth/presentation/cubits/auth_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          content: Text('Insira a imagem e a descrição'),
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
        foregroundColor: AppThemeCustom.gray900,
      ),

      // BODY
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        // tappable image area (empty before selection, adopts image size after)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Builder(
              builder: (context) {
                // show selected image (web)
                if (kIsWeb && webImage != null) {
                  return Stack(
                    children: [
                      Image.memory(
                        webImage!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              webImage = null;
                              imagePickedFile = null;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black12),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: SvgPicture.asset('assets/images/x-icon.svg'),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                // show selected image (mobile/desktop)
                if (!kIsWeb && imagePickedFile?.path != null) {
                  return Stack(
                    children: [
                      Image.file(
                        File(imagePickedFile!.path!),
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              imagePickedFile = null;
                              webImage = null;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black12),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: SvgPicture.asset('assets/images/x-icon.svg'),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                // empty placeholder before selection with centered upload icon; whole area is tappable
                return GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/upload-icon.svg',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: MaterialButton(
              onPressed: uploadPost,
              color: AppThemeCustom.green500,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                "Publicar",
                style: TextStyle(color: AppThemeCustom.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}