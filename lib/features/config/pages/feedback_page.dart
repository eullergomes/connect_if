import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_if/features/services/auth/presentation/cubits/auth_cubit.dart';

import '../../../ui/themes/class_themes.dart';
// import '../../../shared/widgets/button.dart';


class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();
  bool _submitting = false;

  Future<void> _submitFeedback() async {
    if (_submitting) return;
    final sugestao = _controller.text.trim();

    if (_rating == 0 || sugestao.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, dê uma nota e escreva uma sugestão."),
        ),
      );
      return;
    }

    final authCubit = context.read<AuthCubit>();
    final user = authCubit.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("É necessário estar logado para enviar feedback.")),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'userId': user.uid,
        'userName': user.name,
        'userEmail': user.email,
        'rating': _rating,
        'suggestion': sugestao,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Obrigado pelo feedback!")),
      );

      setState(() {
        _rating = 0;
        _controller.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao enviar feedback: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feedback",
          style: TextStyle(
            color: AppThemeCustom.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Como você avalia a experiência?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            // Estrelinhas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 24),
            // Campo de sugestão
            TextField(
              controller: _controller,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                labelText: "Deixe sua sugestão",
                labelStyle: TextStyle(color: AppThemeCustom.green500),
                floatingLabelStyle: TextStyle(color: AppThemeCustom.green500),
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppThemeCustom.green500, width: 2),
                ),
              ),
              minLines: 3,
              maxLines: null, // grows as user types
            ),
            const SizedBox(height: 24),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeCustom.green500,
                foregroundColor: AppThemeCustom.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submitting ? null : _submitFeedback,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Enviar Parecer',
                      style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}