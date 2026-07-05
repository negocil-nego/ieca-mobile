import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class ContentBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Future<Result<List<T>>> future;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? bottom;
  final bool separateActions;

  const ContentBottomSheet({
    super.key,
    this.actions = const [],
    required this.title,
    required this.future,
    required this.itemBuilder,
    this.bottom,
    this.separateActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(AppIcon.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 2),
                if (!separateActions)
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                ...actions.expand(
                  (w) => [const SizedBox(width: 2), w],
                ).skip(1),
                const SizedBox(width: 2),
                IconButton(
                  icon: Icon(AppIcon.report, size: 18, color: AppColors.primary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  tooltip: 'Reportar erro',
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (_) => const ReportErrorSheet(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          if (separateActions)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<Result<List<T>>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final result = snapshot.data;
                if (result == null) {
                  return const Center(child: Text('Nenhum dado encontrado'));
                }

                return result.when(
                  ok: (data) {
                    if (data.isEmpty) {
                      return const Center(child: Text('Nenhum conteúdo encontrado'));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) => itemBuilder(context, data[index], index),
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemCount: data.length,
                    );
                  },
                  error: (error) => Center(child: Text('Erro: $error')),
                );
              },
            ),
          ),
          ?bottom,
        ],
      ),
    );
  }
}