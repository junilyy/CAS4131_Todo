import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/todo_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF1C3F36);
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      scrollBehavior: const _AppScrollBehavior(),
      theme: ThemeData(
        colorScheme: baseScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F1E8),
        fontFamily: 'Georgia',
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF1E1D1A),
          displayColor: const Color(0xFF1E1D1A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.9),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    ref.read(todoListProvider.notifier).addTodo(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoListProvider);
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF7F0E2), Color(0xFFF0E6D7), Color(0xFFE4EDE5)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(20, isWide ? 28 : 20, 20, 28),
                children: [
                  _HeroPanel(todoCount: todos.length),
                  const SizedBox(height: 18),
                  _ComposerCard(controller: _controller, onAdd: _addTodo),
                  const SizedBox(height: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todos.isEmpty ? '오늘의 목록' : '해야 할 일 ${todos.length}개',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        todos.isEmpty
                            ? '새로운 할 일을 추가하면 이 아래에 차분하게 정리돼요.'
                            : '중요한 순서대로 확인하고 하나씩 비워보세요.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6A675F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (todos.isEmpty)
                    const _EmptyStateCard()
                  else ...[
                    for (var index = 0; index < todos.length; index++) ...[
                      _TodoCard(
                        index: index,
                        title: todos[index].title,
                        onDelete: () {
                          ref
                              .read(todoListProvider.notifier)
                              .removeTodo(todos[index].id);
                        },
                      ),
                      if (index != todos.length - 1) const SizedBox(height: 12),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.todoCount});

  final int todoCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15352E), Color(0xFF295447)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F16342D),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY',
            style: theme.textTheme.labelLarge?.copyWith(
              color: const Color(0xFFE7D7BC),
              fontWeight: FontWeight.w700,
              letterSpacing: 2.8,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '해야 할 일을 차분하게\n정리하는 하루',
            style: theme.textTheme.displaySmall?.copyWith(
              color: const Color(0xFFF8F5EF),
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: -1.4,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            todoCount == 0
                ? '새로운 할 일을 적어서 오늘의 흐름을 시작해보세요.'
                : '지금 $todoCount개의 작업이 정리되어 있어요. 가장 중요한 한 가지부터 진행해보세요.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFE7E0D3),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricChip(label: 'Tasks', value: '$todoCount'),
              _MetricChip(
                label: 'Status',
                value: todoCount == 0 ? 'Start' : 'Active',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFEAE3D7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComposerCard extends StatelessWidget {
  const _ComposerCard({required this.controller, required this.onAdd});

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Task',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '간결하게 적어두면 하루의 우선순위가 더 또렷해져요.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6A675F),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: '예: 운동 30분 하기',
                      filled: true,
                      fillColor: const Color(0xFFF5EFE6),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => onAdd(),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 58,
                  child: FilledButton(
                    onPressed: onAdd,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFB98252),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text('추가'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodoCard extends StatelessWidget {
  const _TodoCard({
    required this.index,
    required this.title,
    required this.onDelete,
  });

  final int index;
  final String title;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E1D3),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}'.padLeft(2, '0'),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF1C3F36),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '작은 단위로 하나씩 정리하면 훨씬 수월해져요.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF777168),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            IconButton.filledTonal(
              onPressed: onDelete,
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF3E8DF),
                foregroundColor: const Color(0xFF9F5D40),
              ),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFECE3D3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.draw_outlined,
                size: 34,
                color: Color(0xFF1C3F36),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '등록된 할 일이 없습니다.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '상단 입력창에 오늘 해야 할 일을 적고\n가볍게 시작해보세요.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6A675F),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
