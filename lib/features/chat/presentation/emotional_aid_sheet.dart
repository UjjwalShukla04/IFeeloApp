import 'package:flutter/material.dart';
import '../domain/emotional_intelligence_service.dart';

class EmotionalAidSheet extends StatefulWidget {
  const EmotionalAidSheet({super.key});

  @override
  State<EmotionalAidSheet> createState() => _EmotionalAidSheetState();
}

class _EmotionalAidSheetState extends State<EmotionalAidSheet> {
  String? _myEmotion;
  String? _partnerEmotion;
  String? _stage;
  Map<String, dynamic>? _advice;

  void _generateAdvice() {
    if (_myEmotion != null && _partnerEmotion != null && _stage != null) {
      setState(() {
        _advice = EmotionalIntelligenceService.getAdvice(
          myEmotion: _myEmotion!,
          partnerEmotion: _partnerEmotion!,
          stage: _stage!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.psychology, color: Color(0xFFE94057), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emotional Intelligence Assistant',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Understand the emotional dynamics',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_advice == null) ...[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdown(
                      label: "How are you feeling?",
                      value: _myEmotion,
                      items: EmotionalIntelligenceService.emotions,
                      onChanged: (val) => setState(() => _myEmotion = val),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: "How do they seem?",
                      value: _partnerEmotion,
                      items: EmotionalIntelligenceService.emotions,
                      onChanged: (val) => setState(() => _partnerEmotion = val),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: "Relationship Stage",
                      value: _stage,
                      items: EmotionalIntelligenceService.stages,
                      onChanged: (val) => setState(() => _stage = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (_myEmotion != null &&
                        _partnerEmotion != null &&
                        _stage != null)
                    ? _generateAdvice
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94057),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  disabledBackgroundColor: Colors.grey[200],
                ),
                child: const Text(
                  'Get Guidance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultCard(
                      icon: Icons.lightbulb_outline,
                      title: "Context Summary",
                      content: _advice!['summary'],
                      color: Colors.amber.shade50,
                      iconColor: Colors.amber.shade800,
                    ),
                    const SizedBox(height: 16),
                    _buildResultCard(
                      icon: Icons.favorite_border,
                      title: "Emotional Needs",
                      content: _advice!['needs'],
                      color: Colors.pink.shade50,
                      iconColor: Colors.pink.shade800,
                    ),
                    const SizedBox(height: 16),
                    _buildResultCard(
                      icon: Icons.record_voice_over,
                      title: "Suggested Tone",
                      content: _advice!['tone'],
                      color: Colors.blue.shade50,
                      iconColor: Colors.blue.shade800,
                    ),
                    const SizedBox(height: 16),
                    _buildResultCard(
                      icon: Icons.warning_amber_rounded,
                      title: "Be Mindful Of",
                      content: _advice!['caution'],
                      color: Colors.orange.shade50,
                      iconColor: Colors.orange.shade800,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(() => _advice = null),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Start Over',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                'Select...',
                style: TextStyle(color: Colors.grey[500]),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
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

class FeelingPromptSheet extends StatefulWidget {
  final void Function(String feeling) onSubmit;

  const FeelingPromptSheet({super.key, required this.onSubmit});

  @override
  State<FeelingPromptSheet> createState() => _FeelingPromptSheetState();
}

class _FeelingPromptSheetState extends State<FeelingPromptSheet> {
  String? _feeling;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.psychology, color: Color(0xFFE94057), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emotional Intelligence Assistant',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share how you feel about this chat',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'How are you feeling?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _feeling,
                isExpanded: true,
                hint: Text(
                  'Select...',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                items: EmotionalIntelligenceService.emotions.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _feeling = value;
                  });
                },
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _feeling == null
                  ? null
                  : () {
                      widget.onSubmit(_feeling!);
                      Navigator.of(context).pop();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE94057),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                disabledBackgroundColor: Colors.grey[200],
              ),
              child: const Text(
                'Share',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
