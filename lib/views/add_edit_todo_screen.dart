import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../viewmodels/todo_viewmodel.dart';

class AddEditTodoScreen extends StatefulWidget {
  final TodoModel? todo;

  const AddEditTodoScreen({
    super.key,
    this.todo,
  });

  @override
  State<AddEditTodoScreen> createState() =>
      _AddEditTodoScreenState();
}

class _AddEditTodoScreenState
    extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  bool _isSaving = false;

  bool get isEditMode => widget.todo != null;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.todo?.title ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.todo?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // =========================================================
  // SAVE TODO
  // =========================================================

  Future<void> _saveTodo() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final viewModel = context.read<TodoViewModel>();

    try {
      if (isEditMode) {
        final updatedTodo = widget.todo!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        );

        await viewModel.updateTodo(updatedTodo);
      } else {
        await viewModel.addTodo(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode
                ? 'TODO updated successfully'
                : 'TODO added successfully',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF10B981),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong: $e',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER
            // =================================================

            _buildHeader(),

            // =================================================
            // FORM
            // =================================================

            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // Page heading
                      Text(
                        isEditMode
                            ? 'Update your task'
                            : 'Create a new task',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        isEditMode
                            ? 'Make changes to your TODO below.'
                            : 'Add the details of your new TODO.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // =================================================
                      // TITLE
                      // =================================================

                      _buildFieldLabel(
                        'TODO Title',
                        Icons.title_rounded,
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _titleController,
                        textInputAction:
                        TextInputAction.next,
                        textCapitalization:
                        TextCapitalization.sentences,
                        maxLength: 80,
                        decoration: _inputDecoration(
                          hintText:
                          'Enter your TODO title',
                          prefixIcon:
                          Icons.task_alt_rounded,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter a TODO title';
                          }

                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // =================================================
                      // DESCRIPTION
                      // =================================================

                      _buildFieldLabel(
                        'Description',
                        Icons.description_outlined,
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller:
                        _descriptionController,
                        textCapitalization:
                        TextCapitalization.sentences,
                        maxLines: 6,
                        maxLength: 500,
                        decoration: _inputDecoration(
                          hintText:
                          'Add more details about this task...',
                          prefixIcon:
                          Icons.notes_rounded,
                          alignLabelWithHint: true,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =================================================
                      // TIP CARD
                      // =================================================

                      _buildTipCard(),

                      const SizedBox(height: 28),

                      // =================================================
                      // SAVE BUTTON
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                          _isSaving ? null : _saveTodo,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                            const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                            const Color(0xFF93C5FD),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(
                                isEditMode
                                    ? Icons
                                    .save_outlined
                                    : Icons
                                    .add_task_rounded,
                                size: 21,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isEditMode
                                    ? 'Update TODO'
                                    : 'Create TODO',
                                style:
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Cancel button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: TextButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                            const Color(0xFF6B7280),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        14,
        20,
        22,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2563EB),
            Color(0xFF4F46E5),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          // Back button
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: IconButton(
              onPressed: _isSaving
                  ? null
                  : () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Header icon
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isEditMode
                  ? Icons.edit_note_rounded
                  : Icons.add_task_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  isEditMode
                      ? 'Edit TODO'
                      : 'New TODO',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isEditMode
                      ? 'Update task details'
                      : 'Create a new task',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FIELD LABEL
  // =========================================================

  Widget _buildFieldLabel(
      String label,
      IconData icon,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF2563EB),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // INPUT DECORATION
  // =========================================================

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 14,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
        ),
        child: Icon(
          prefixIcon,
          color: const Color(0xFF6B7280),
          size: 21,
        ),
      ),
      prefixIconConstraints:
      const BoxConstraints(
        minWidth: 48,
      ),
      alignLabelWithHint: alignLabelWithHint,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF2563EB),
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),

      counterStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 11,
      ),
    );
  }

  // =========================================================
  // TIP CARD
  // =========================================================

  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDBEAFE),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFF2563EB),
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Tip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Keep your task title short and use the description for additional details.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
