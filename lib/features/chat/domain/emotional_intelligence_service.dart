class EmotionalIntelligenceService {
  // Mock AI response generator based on the prompt rules
  static Map<String, dynamic> getAdvice({
    required String myEmotion,
    required String partnerEmotion,
    required String stage,
  }) {
    // This is a simple rule-based mock. In a real app, this would call an LLM.

    String summary = '';
    String needs = '';
    String tone = '';
    String caution = '';

    // Logic for "Anxious" + "Distant" (Common scenario)
    if (myEmotion == 'Anxious' && partnerEmotion == 'Distant') {
      summary =
          "You may feel a need for reassurance while they might need space or are simply busy. This dynamic often creates a 'pursuer-distancer' loop.";
      needs = "Reassurance for you; Autonomy/Space for them.";
      tone = "Calm, self-soothing, and non-demanding. Open but not urgent.";
      caution =
          "Avoid double-texting or asking 'Are you mad?'. Give it a little time.";
    }
    // Logic for "Excited" + "Neutral"
    else if (myEmotion == 'Excited' && partnerEmotion == 'Neutral') {
      summary =
          "Your high energy might be meeting their steady baseline. It doesn't mean they aren't interested, just expressing it differently.";
      needs = "Shared enthusiasm for you; Consistency/Pacing for them.";
      tone =
          "Warm and inviting, without pressure to match your energy level immediately.";
      caution =
          "Don't interpret their calmness as boredom. Keep the vibe light.";
    }
    // Logic for "Frustrated" + "Defensive"
    else if (myEmotion == 'Frustrated' && partnerEmotion == 'Defensive') {
      summary =
          "Tension is high. You want to be heard, and they want to protect themselves. Communication is likely blocked right now.";
      needs = "Validation for you; Safety for them.";
      tone = "De-escalating, 'I' statements, and soft start-ups.";
      caution =
          "Avoid accusations or 'You always...' statements. Pause if needed.";
    }
    // Default / Generic fallback
    else {
      summary =
          "This combination suggests a mix of $myEmotion and $partnerEmotion energy. In the '$stage' stage, clarity is key.";
      needs = "Mutual understanding and patience.";
      tone = "Curious, open, and respectful of both perspectives.";
      caution = "Avoid assumptions. If unsure, ask gently for clarification.";
    }

    return {
      'summary': summary,
      'needs': needs,
      'tone': tone,
      'caution': caution,
    };
  }

  static const List<String> emotions = [
    'Happy',
    'Excited',
    'Nervous',
    'Anxious',
    'Frustrated',
    'Neutral',
    'Distant',
    'Defensive',
    'Sad',
    'Confused',
  ];

  static const List<String> stages = [
    'New Match',
    'Early Chat',
    'Ongoing',
    'Reconnecting',
    'Dating',
  ];
}
