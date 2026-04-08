import '../models/exercise_model.dart';

class ExerciseService {

  static Future<List<ExerciseItem>> getRecommendations(String bmiCategory) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _data[bmiCategory] ?? _data['Normal']!;
  }

  static final Map<String, List<ExerciseItem>> _data = {

    // ── 偏瘦：增肌，大重量复合动作 ──────────────────────────────
    'Underweight': [
      ExerciseItem(name: 'Push Up',        category: 'Chest',    description: 'Start in plank position. Lower your chest to the floor, then push back up. Keep your body straight.', sets: 4, reps: 10, unit: 'reps'),
      ExerciseItem(name: 'Squat',          category: 'Legs',     description: 'Stand with feet shoulder-width apart. Bend your knees and lower your hips until thighs are parallel to floor, then stand back up.', sets: 4, reps: 12, unit: 'reps'),
      ExerciseItem(name: 'Pull Up',        category: 'Back',     description: 'Hang from a bar with both hands. Pull your body up until your chin is above the bar, then lower slowly.', sets: 3, reps: 8, unit: 'reps'),
      ExerciseItem(name: 'Dumbbell Curl',  category: 'Arms',     description: 'Hold dumbbells at your sides. Curl them up toward your shoulders, then lower slowly.', sets: 3, reps: 12, unit: 'reps'),
      ExerciseItem(name: 'Shoulder Press', category: 'Shoulders',description: 'Hold dumbbells at shoulder height. Press them straight up overhead, then lower back down.', sets: 3, reps: 10, unit: 'reps'),
      ExerciseItem(name: 'Plank',          category: 'Core',     description: 'Hold a push-up position on your forearms. Keep your body in a straight line and hold.', sets: 3, reps: 30, unit: 'seconds'),
      ExerciseItem(name: 'Lunge',          category: 'Legs',     description: 'Step one foot forward and lower your back knee toward the floor. Push back up and repeat with the other leg.', sets: 3, reps: 10, unit: 'reps'),
    ],

    // ── 正常：均衡训练 ───────────────────────────────────────────
    'Normal': [
      ExerciseItem(name: 'Push Up',           category: 'Chest', description: 'Start in plank position. Lower your chest to the floor, then push back up. Keep your body straight.', sets: 3, reps: 15, unit: 'reps'),
      ExerciseItem(name: 'Bodyweight Squat',  category: 'Legs',  description: 'Stand with feet shoulder-width apart. Bend your knees and lower your hips until thighs are parallel to floor, then stand back up.', sets: 3, reps: 20, unit: 'reps'),
      ExerciseItem(name: 'Plank',             category: 'Core',  description: 'Hold a push-up position on your forearms. Keep your body in a straight line and hold.', sets: 3, reps: 45, unit: 'seconds'),
      ExerciseItem(name: 'Jumping Jack',      category: 'Cardio',description: 'Jump while spreading your legs and raising your arms overhead. Land and bring them back together. Repeat continuously.', sets: 3, reps: 30, unit: 'reps'),
      ExerciseItem(name: 'Bicycle Crunch',    category: 'Core',  description: 'Lie on your back with hands behind head. Bring one elbow to the opposite knee while extending the other leg. Alternate sides.', sets: 3, reps: 20, unit: 'reps'),
      ExerciseItem(name: 'Glute Bridge',      category: 'Legs',  description: 'Lie on your back with knees bent. Push your hips up toward the ceiling, squeeze your glutes, then lower back down.', sets: 3, reps: 15, unit: 'reps'),
      ExerciseItem(name: 'Tricep Dip',        category: 'Arms',  description: 'Place hands on a chair behind you, legs straight. Bend elbows to lower your body, then push back up.', sets: 3, reps: 12, unit: 'reps'),
    ],

    // ── 超重：有氧 + 核心，多次数 ────────────────────────────────
    'Overweight': [
      ExerciseItem(name: 'Brisk Walking',     category: 'Cardio', description: 'Walk at a fast pace where you can still talk but feel slightly breathless. Swing your arms naturally.', sets: 1, reps: 30, unit: 'minutes'),
      ExerciseItem(name: 'Bodyweight Squat',  category: 'Legs',   description: 'Stand with feet shoulder-width apart. Bend your knees and lower your hips until thighs are parallel to floor, then stand back up.', sets: 3, reps: 20, unit: 'reps'),
      ExerciseItem(name: 'Wall Push Up',      category: 'Chest',  description: 'Stand facing a wall. Place hands at chest height. Bend elbows to bring chest toward wall, then push back out.', sets: 3, reps: 15, unit: 'reps'),
      ExerciseItem(name: 'Standing Crunch',   category: 'Core',   description: 'Stand with hands behind head. Lift one knee while lowering the same-side elbow to meet it. Alternate sides.', sets: 3, reps: 20, unit: 'reps'),
      ExerciseItem(name: 'Step Up',           category: 'Legs',   description: 'Step one foot onto a sturdy chair or step. Push through that foot to bring your body up, then step back down.', sets: 3, reps: 12, unit: 'reps'),
      ExerciseItem(name: 'Plank',             category: 'Core',   description: 'Hold a push-up position on your forearms. Keep your body in a straight line and hold.', sets: 3, reps: 30, unit: 'seconds'),
      ExerciseItem(name: 'Calf Raise',        category: 'Legs',   description: 'Stand with feet flat. Rise up onto your toes as high as you can, hold for 1 second, then lower back down.', sets: 3, reps: 20, unit: 'reps'),
    ],

    // ── 肥胖：低强度，从椅子动作开始 ─────────────────────────────
    'Obese': [
      ExerciseItem(name: 'Seated March',      category: 'Cardio', description: 'Sit in a chair. Lift one knee up toward your chest, lower it, then lift the other. Alternate at a comfortable pace.', sets: 2, reps: 30, unit: 'seconds'),
      ExerciseItem(name: 'Chair Squat',       category: 'Legs',   description: 'Stand in front of a chair. Slowly sit down, pause briefly, then stand back up using your legs — not your arms.', sets: 2, reps: 10, unit: 'reps'),
      ExerciseItem(name: 'Wall Push Up',      category: 'Chest',  description: 'Stand facing a wall. Place hands at chest height. Bend elbows to bring chest toward wall, then push back out.', sets: 2, reps: 10, unit: 'reps'),
      ExerciseItem(name: 'Seated Leg Raise',  category: 'Core',   description: 'Sit in a chair. Straighten one leg and hold it up for 3 seconds, then lower. Alternate legs.', sets: 2, reps: 10, unit: 'reps'),
      ExerciseItem(name: 'Arm Circle',        category: 'Arms',   description: 'Extend both arms out to the sides. Make small circles forward for 15 seconds, then backward for 15 seconds.', sets: 2, reps: 30, unit: 'seconds'),
      ExerciseItem(name: 'Standing March',    category: 'Cardio', description: 'Stand holding a chair for balance. Lift your knees one at a time as if marching on the spot. Keep a comfortable rhythm.', sets: 2, reps: 30, unit: 'seconds'),
    ],
  };
}