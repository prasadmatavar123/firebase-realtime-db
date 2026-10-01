import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo_model.dart';
import '../viewmodels/todo_viewmodel.dart';
import 'add_edit_todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _deleteTodo(
      BuildContext context,
      TodoModel todo,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text('Delete TODO'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${todo.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await context.read<TodoViewModel>().deleteTodo(todo.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('TODO deleted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Consumer<TodoViewModel>(
        builder: (context, viewModel, child) {
          final todos = viewModel.todos;

          final totalTodos = todos.length;

          final completedTodos =
              todos.where((todo) => todo.isCompleted).length;

          final pendingTodos =
              todos.where((todo) => !todo.isCompleted).length;

          return CustomScrollView(
            slivers: [
              // -------------------------------------------------
              // HEADER
              // -------------------------------------------------
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    55,
                    24,
                    28,
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
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),

                          const Spacer(),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'My TODOs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Stay organized and get things done.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Progress
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                value: totalTodos == 0
                                    ? 0
                                    : completedTodos /
                                    totalTodos,
                                backgroundColor:
                                Colors.white.withOpacity(0.2),
                                valueColor:
                                const AlwaysStoppedAnimation<
                                    Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Text(
                            totalTodos == 0
                                ? '0%'
                                : '${((completedTodos / totalTodos) * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // -------------------------------------------------
              // STATISTICS
              // -------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    22,
                    20,
                    10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.list_alt_rounded,
                          title: 'Total',
                          value: totalTodos.toString(),
                          iconColor: const Color(0xFF2563EB),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.pending_actions_rounded,
                          title: 'Pending',
                          value: pendingTodos.toString(),
                          iconColor: const Color(0xFFF59E0B),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.task_alt_rounded,
                          title: 'Done',
                          value: completedTodos.toString(),
                          iconColor: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // -------------------------------------------------
              // SECTION TITLE
              // -------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    12,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Your Tasks',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),

                      const Spacer(),

                      Text(
                        '$totalTodos tasks',
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // -------------------------------------------------
              // TODO LIST
              // -------------------------------------------------
              if (todos.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    100,
                  ),
                  sliver: SliverList.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];

                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 12),
                        child: _buildTodoCard(
                          context,
                          todo,
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),

      // -------------------------------------------------
      // ADD BUTTON
      // -------------------------------------------------
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTodoScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'Add TODO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // STAT CARD
  // =========================================================

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TODO CARD
  // =========================================================

  Widget _buildTodoCard(
      BuildContext context,
      TodoModel todo,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: todo.isCompleted
              ? const Color(0xFFD1FAE5)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            GestureDetector(
              onTap: () {
                context
                    .read<TodoViewModel>()
                    .toggleTodo(todo);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: todo.isCompleted
                      ? const Color(0xFF10B981)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: todo.isCompleted
                        ? const Color(0xFF10B981)
                        : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                ),
                child: todo.isCompleted
                    ? const Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                )
                    : null,
              ),
            ),

            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: todo.isCompleted
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF111827),
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  if (todo.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      todo.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: todo.isCompleted
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: todo.isCompleted
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFFFF7ED),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      todo.isCompleted
                          ? 'Completed'
                          : 'Pending',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: todo.isCompleted
                            ? const Color(0xFF059669)
                            : const Color(0xFFD97706),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Menu
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Color(0xFF6B7280),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddEditTodoScreen(todo: todo),
                    ),
                  );
                }

                if (value == 'delete') {
                  _deleteTodo(context, todo);
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 52,
                color: Color(0xFF2563EB),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'No Tasks Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Start organizing your day by adding your first TODO.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const AddEditTodoScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create TODO'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

