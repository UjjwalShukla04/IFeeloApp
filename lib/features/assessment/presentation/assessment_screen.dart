import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

enum _QuestionType { forcedChoice, multipleChoice, scale }

class _Option {
  final String id;
  final String text;

  const _Option({required this.id, required this.text});
}

class _Question {
  final String id;
  final String text;
  final _QuestionType type;
  final List<_Option> options;

  const _Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
  });
}

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  static const String _assetPath = 'assets/eq_assessment/questions.json';

  bool _loading = true;
  String? _loadError;
  List<_Question> _questions = const [];
  int _index = 0;
  bool _submitting = false;

  String? _selectedOptionId;
  String? _mostOptionId;
  String? _leastOptionId;
  int? _scaleValue;

  final List<Map<String, dynamic>> _answers = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final raw = await rootBundle.loadString(_assetPath);
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final sections = (decoded['sections'] as List)
          .cast<Map<String, dynamic>>();

      final flattened = <_Question>[];
      for (final section in sections) {
        final questions = (section['questions'] as List)
            .cast<Map<String, dynamic>>();
        for (final q in questions) {
          final typeString = (q['type'] as String).toLowerCase().trim();
          final type = switch (typeString) {
            'forced_choice' => _QuestionType.forcedChoice,
            'multiple_choice' => _QuestionType.multipleChoice,
            'scale' => _QuestionType.scale,
            'scale_1_5' => _QuestionType.scale,
            _ => _QuestionType.multipleChoice,
          };

          final rawOptions = (q['options'] as List?)
              ?.cast<Map<String, dynamic>>();
          final options = (rawOptions ?? const [])
              .map(
                (o) => _Option(
                  id: (o['id'] ?? o['label'] ?? '').toString(),
                  text: (o['text'] ?? '').toString(),
                ),
              )
              .where((o) => o.id.isNotEmpty && o.text.isNotEmpty)
              .toList(growable: false);

          flattened.add(
            _Question(
              id: (q['id'] ?? '').toString(),
              text: (q['text'] ?? '').toString(),
              type: type,
              options: options,
            ),
          );
        }
      }

      if (!mounted) return;
      setState(() {
        _questions = flattened;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString();
        _loading = false;
      });
    }
  }

  bool _canProceed(_Question q) {
    switch (q.type) {
      case _QuestionType.multipleChoice:
        return _selectedOptionId != null;
      case _QuestionType.forcedChoice:
        return _mostOptionId != null && _leastOptionId != null;
      case _QuestionType.scale:
        return _scaleValue != null;
    }
  }

  void _resetInputs() {
    _selectedOptionId = null;
    _mostOptionId = null;
    _leastOptionId = null;
    _scaleValue = null;
  }

  Future<void> _next() async {
    final q = _questions[_index];
    if (!_canProceed(q)) return;

    final payload = <String, dynamic>{"question_id": q.id, "type": q.type.name};

    switch (q.type) {
      case _QuestionType.multipleChoice:
        payload["selected_option"] = _selectedOptionId;
        break;
      case _QuestionType.forcedChoice:
        payload["most"] = _mostOptionId;
        payload["least"] = _leastOptionId;
        break;
      case _QuestionType.scale:
        payload["value"] = _scaleValue;
        break;
    }

    _answers.add(payload);

    if (_index < _questions.length - 1) {
      setState(() {
        _index += 1;
        _resetInputs();
      });
      return;
    }

    await _submit();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await ApiService.submitAssessment(_answers);
      if (!mounted) return;
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Assessment submit failed: $e')));
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loadError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Failed to load assessment questions: $_loadError'),
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    final q = _questions[_index];
    final progress = (_index + 1) / _questions.length;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('EQ Assessment (${_index + 1}/${_questions.length})'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(value: progress),
          ),
        ),
        body: _submitting
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(q.text, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Expanded(child: _buildQuestion(q)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _canProceed(q) ? _next : null,
                      child: Text(
                        _index == _questions.length - 1 ? 'Submit' : 'Next',
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildQuestion(_Question q) {
    switch (q.type) {
      case _QuestionType.multipleChoice:
        return ListView.separated(
          itemCount: q.options.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final opt = q.options[i];
            final selected = _selectedOptionId == opt.id;
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: selected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              title: Text(opt.text),
              onTap: () => setState(() => _selectedOptionId = opt.id),
            );
          },
        );

      case _QuestionType.forcedChoice:
        return ListView.separated(
          itemCount: q.options.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final opt = q.options[i];
            final most = _mostOptionId == opt.id;
            final least = _leastOptionId == opt.id;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(opt.text),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              if (_leastOptionId == opt.id) {
                                _leastOptionId = null;
                              }
                              _mostOptionId = opt.id;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: most
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                          ),
                          child: const Text('MOST'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              if (_mostOptionId == opt.id) {
                                _mostOptionId = null;
                              }
                              _leastOptionId = opt.id;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: least
                                ? Theme.of(context).colorScheme.errorContainer
                                : null,
                          ),
                          child: const Text('LEAST'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );

      case _QuestionType.scale:
        return Column(
          children: [
            const Text('1 = Strongly Disagree   |   5 = Strongly Agree'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: List.generate(5, (i) {
                final value = i + 1;
                final selected = _scaleValue == value;
                return ChoiceChip(
                  label: Text(value.toString()),
                  selected: selected,
                  onSelected: (_) => setState(() => _scaleValue = value),
                );
              }),
            ),
          ],
        );
    }
  }
}
