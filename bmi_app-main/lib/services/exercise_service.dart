import '../models/exercise_model.dart';
import '../models/goal_model.dart';

class ExerciseService {

  static Future<List<ExerciseItem>> getRecommendations(
    String bmiCategory, {
    UserGoal? goal,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getData(bmiCategory, goal);
  }

  static List<ExerciseItem> _getData(String bmiCategory, UserGoal? goal) {

    // ── Build Muscle（任何 BMI 都用这套）────────────────────────
    if (goal == UserGoal.buildMuscle) {
      return [
        ExerciseItem(name: 'Barbell Squat',    category: 'Legs',     description: 'Stand with feet shoulder-width apart. Hold barbell on upper back. Bend knees and lower until thighs are parallel, then drive back up.', sets: 4, reps: 8, unit: 'reps'),
        ExerciseItem(name: 'Bench Press',      category: 'Chest',    description: 'Lie on a bench, grip bar slightly wider than shoulder width. Lower to chest, then press up explosively. Keep feet flat on floor.', sets: 4, reps: 8, unit: 'reps'),
        ExerciseItem(name: 'Deadlift',         category: 'Back',     description: 'Stand with feet hip-width, grip bar outside knees. Keep back straight, push through heels to stand, then lower with control.', sets: 4, reps: 6, unit: 'reps'),
        ExerciseItem(name: 'Pull Up',          category: 'Back',     description: 'Hang from bar with overhand grip. Pull body up until chin clears the bar, then lower slowly. Engage lats throughout.', sets: 3, reps: 8, unit: 'reps'),
        ExerciseItem(name: 'Overhead Press',   category: 'Shoulders',description: 'Stand with barbell at shoulder height. Press straight overhead until arms are fully extended, then lower back to shoulders.', sets: 3, reps: 10, unit: 'reps'),
        ExerciseItem(name: 'Dumbbell Curl',    category: 'Arms',     description: 'Hold dumbbells at sides. Curl both up toward shoulders, squeeze at the top, then lower slowly. Keep elbows close to body.', sets: 3, reps: 12, unit: 'reps'),
        ExerciseItem(name: 'Plank',            category: 'Core',     description: 'Hold a push-up position on your forearms. Keep body in a straight line from head to heels. Breathe steadily and hold.', sets: 3, reps: 45, unit: 'seconds'),
      ];
    }

    // ── Lose Weight（任何 BMI 都用这套）────────────────────────
    if (goal == UserGoal.loseWeight) {
      return [
        ExerciseItem(name: 'Brisk Walking',    category: 'Cardio',   description: 'Walk at a fast pace where you feel slightly breathless but can still talk. Swing arms naturally. Aim for 30 minutes continuously.', sets: 1, reps: 30, unit: 'minutes'),
        ExerciseItem(name: 'Jumping Jack',     category: 'Cardio',   description: 'Jump while spreading legs and raising arms overhead simultaneously. Land softly and repeat at a steady rhythm.', sets: 4, reps: 30, unit: 'reps'),
        ExerciseItem(name: 'Bodyweight Squat', category: 'Legs',     description: 'Feet shoulder-width apart, toes slightly out. Lower hips until thighs are parallel, then stand back up. Keep chest up.', sets: 3, reps: 20, unit: 'reps'),
        ExerciseItem(name: 'Mountain Climber', category: 'Core',     description: 'Start in plank position. Drive one knee toward chest, then quickly switch legs. Keep hips level and core tight throughout.', sets: 3, reps: 30, unit: 'reps'),
        ExerciseItem(name: 'High Knee Run',    category: 'Cardio',   description: 'Run in place while lifting knees as high as possible with each step. Pump arms in rhythm. Maintain a fast pace.', sets: 3, reps: 30, unit: 'seconds'),
        ExerciseItem(name: 'Burpee',           category: 'Cardio',   description: 'From standing, drop hands to floor, jump feet back to plank, do a push-up, jump feet forward, then jump up with arms overhead.', sets: 3, reps: 10, unit: 'reps'),
        ExerciseItem(name: 'Plank',            category: 'Core',     description: 'Hold a push-up position on your forearms. Keep body in a straight line from head to heels. Breathe steadily and hold.', sets: 3, reps: 30, unit: 'seconds'),
      ];
    }

    // ── Improve Stamina ─────────────────────────────────────────
    if (goal == UserGoal.improveStamina) {
      return [
        ExerciseItem(name: 'Jogging',          category: 'Cardio',   description: 'Run at a comfortable pace where you can hold a conversation. Focus on consistent breathing and maintaining your rhythm throughout.', sets: 1, reps: 20, unit: 'minutes'),
        ExerciseItem(name: 'Jump Rope',        category: 'Cardio',   description: 'Skip rope at a steady rhythm. Keep elbows close to sides, rotate wrists, and land softly on the balls of your feet.', sets: 3, reps: 60, unit: 'seconds'),
        ExerciseItem(name: 'Cycling',          category: 'Cardio',   description: 'Cycle at a moderate pace, maintaining a consistent cadence. Keep your back straight and core engaged throughout the session.', sets: 1, reps: 20, unit: 'minutes'),
        ExerciseItem(name: 'Bodyweight Squat', category: 'Legs',     description: 'Feet shoulder-width apart. Lower hips until thighs are parallel to floor. Drive through heels to stand. Repeat at a controlled pace.', sets: 3, reps: 20, unit: 'reps'),
        ExerciseItem(name: 'Plank',            category: 'Core',     description: 'Hold a push-up position on forearms. Keep body straight from head to heels. Breathe steadily. Increase hold time as you progress.', sets: 3, reps: 45, unit: 'seconds'),
        ExerciseItem(name: 'Glute Bridge',     category: 'Legs',     description: 'Lie on back with knees bent. Push hips toward ceiling, squeeze glutes at top, then lower. Keep core tight throughout.', sets: 3, reps: 15, unit: 'reps'),
        ExerciseItem(name: 'Bear Crawl',       category: 'Core',     description: 'On all fours with knees just above the floor. Move opposite hand and foot forward simultaneously. Keep back flat and hips low.', sets: 3, reps: 30, unit: 'seconds'),
      ];
    }

    // ── Stay Healthy ────────────────────────────────────────────
    if (goal == UserGoal.stayHealthy) {
      return [
        ExerciseItem(name: 'Push Up',          category: 'Chest',    description: 'Start in plank. Lower chest toward floor, keeping elbows at 45 degrees. Push back up until arms are fully extended.', sets: 3, reps: 15, unit: 'reps'),
        ExerciseItem(name: 'Bodyweight Squat', category: 'Legs',     description: 'Feet shoulder-width apart. Lower hips until thighs are parallel, then stand. Keep chest up and knees over toes.', sets: 3, reps: 15, unit: 'reps'),
        ExerciseItem(name: 'Plank',            category: 'Core',     description: 'Hold push-up position on forearms. Keep body in a straight line. Engage core and breathe steadily.', sets: 3, reps: 30, unit: 'seconds'),
        ExerciseItem(name: 'Jumping Jack',     category: 'Cardio',   description: 'Jump while spreading legs and raising arms. Land softly and repeat at a steady pace. Good warm-up exercise.', sets: 3, reps: 20, unit: 'reps'),
        ExerciseItem(name: 'Lunge',            category: 'Legs',     description: 'Step one foot forward and lower the back knee toward the floor. Push back to start and repeat with the other leg.', sets: 3, reps: 12, unit: 'reps'),
        ExerciseItem(name: 'Glute Bridge',     category: 'Legs',     description: 'Lie on back, knees bent. Push hips up and squeeze glutes at the top. Lower slowly and repeat.', sets: 3, reps: 15, unit: 'reps'),
        ExerciseItem(name: 'Bicycle Crunch',   category: 'Core',     description: 'Lie on back, hands behind head. Bring one elbow to the opposite knee while extending the other leg. Alternate sides.', sets: 3, reps: 20, unit: 'reps'),
      ];
    }

    // ── 没有目标，用 BMI 类别 ────────────────────────────────────
    final data = {
      'Underweight': [
        ExerciseItem(name: 'Push Up',         category: 'Chest',    description: 'Start in plank. Lower chest to floor then push back up. Keep body straight throughout.', sets: 4, reps: 10, unit: 'reps'),
        ExerciseItem(name: 'Squat',           category: 'Legs',     description: 'Feet shoulder-width apart. Lower until thighs are parallel to floor, then stand back up.', sets: 4, reps: 12, unit: 'reps'),
        ExerciseItem(name: 'Pull Up',         category: 'Back',     description: 'Hang from bar and pull body up until chin clears the bar. Lower slowly.', sets: 3, reps: 8, unit: 'reps'),
        ExerciseItem(name: 'Dumbbell Curl',   category: 'Arms',     description: 'Curl dumbbells up toward shoulders, squeeze at top, then lower slowly.', sets: 3, reps: 12, unit: 'reps'),
        ExerciseItem(name: 'Overhead Press',  category: 'Shoulders',description: 'Press dumbbells from shoulder height straight overhead, then lower back down.', sets: 3, reps: 10, unit: 'reps'),
        ExerciseItem(name: 'Plank',           category: 'Core',     description: 'Hold push-up position on forearms. Keep body straight. Breathe steadily.', sets: 3, reps: 30, unit: 'seconds'),
        ExerciseItem(name: 'Lunge',           category: 'Legs',     description: 'Step forward and lower back knee toward floor. Alternate legs.', sets: 3, reps: 10, unit: 'reps'),
      ],
      'Normal': [
        ExerciseItem(name: 'Push Up',           category: 'Chest',  description: 'Lower chest to floor then push back up. Keep body in a straight line.', sets: 3, reps: 15, unit: 'reps'),
        ExerciseItem(name: 'Bodyweight Squat',  category: 'Legs',   description: 'Lower hips until thighs are parallel to floor, then stand back up.', sets: 3, reps: 20, unit: 'reps'),
        ExerciseItem(name: 'Plank',             category: 'Core',   description: 'Hold push-up position on forearms. Keep body straight and breathe steadily.', sets: 3, reps: 45, unit: 'seconds'),
        ExerciseItem(name: 'Jumping Jack',      category: 'Cardio', description: 'Jump while spreading legs and raising arms. Land softly and repeat.', sets: 3, reps: 30, unit: 'reps'),
        ExerciseItem(name: 'Bicycle Crunch',    category: 'Core',   description: 'Alternate elbow to opposite knee while extending the other leg.', sets: 3, reps: 20, unit: 'reps'),
        ExerciseItem(name: 'Glute Bridge',      category: 'Legs',   description: 'Push hips toward ceiling and squeeze glutes at the top, then lower.', sets: 3, reps: 15, unit: 'reps'),
        ExerciseItem(name: 'Tricep Dip',        category: 'Arms',   description: 'Hands on chair behind you. Bend elbows to lower body then push back up.', sets: 3, reps: 12, unit: 'reps'),
      ],
      'Overweight': [
        ExerciseItem(name: 'Brisk Walking',     category: 'Cardio', description: 'Walk at a fast pace. Aim for 30 minutes continuously.', sets: 1, reps: 30, unit: 'minutes'),
        ExerciseItem(name: 'Bodyweight Squat',  category: 'Legs',   description: 'Lower hips to parallel then stand. Keep chest up and knees over toes.', sets: 3, reps: 20, unit: 'reps'),
        ExerciseItem(name: 'Wall Push Up',      category: 'Chest',  description: 'Hands on wall at chest height. Bend elbows to bring chest to wall, then push out.', sets: 3, reps: 15, unit: 'reps'),
        ExerciseItem(name: 'Standing Crunch',   category: 'Core',   description: 'Lift one knee while lowering same-side elbow to meet it. Alternate sides.', sets: 3, reps: 20, unit: 'reps'),
        ExerciseItem(name: 'Step Up',           category: 'Legs',   description: 'Step one foot onto a chair, push up to bring body level, then step back down.', sets: 3, reps: 12, unit: 'reps'),
        ExerciseItem(name: 'Plank',             category: 'Core',   description: 'Hold push-up position on forearms. Keep body straight.', sets: 3, reps: 30, unit: 'seconds'),
        ExerciseItem(name: 'Calf Raise',        category: 'Legs',   description: 'Rise onto toes as high as possible, hold 1 second, then lower.', sets: 3, reps: 20, unit: 'reps'),
      ],
      'Obese': [
        ExerciseItem(name: 'Seated March',      category: 'Cardio', description: 'Sit in a chair and lift knees alternately at a comfortable pace.', sets: 2, reps: 30, unit: 'seconds'),
        ExerciseItem(name: 'Chair Squat',       category: 'Legs',   description: 'Slowly sit down to a chair then stand back up using your legs, not your arms.', sets: 2, reps: 10, unit: 'reps'),
        ExerciseItem(name: 'Wall Push Up',      category: 'Chest',  description: 'Hands on wall at chest height. Bend elbows toward wall then push out.', sets: 2, reps: 10, unit: 'reps'),
        ExerciseItem(name: 'Seated Leg Raise',  category: 'Core',   description: 'Sit in chair, straighten one leg and hold for 3 seconds. Alternate legs.', sets: 2, reps: 10, unit: 'reps'),
        ExerciseItem(name: 'Arm Circle',        category: 'Arms',   description: 'Extend arms sideways. Make small circles forward for 15 seconds then backward.', sets: 2, reps: 30, unit: 'seconds'),
        ExerciseItem(name: 'Standing March',    category: 'Cardio', description: 'Hold chair for balance. Lift knees one at a time in a marching motion.', sets: 2, reps: 30, unit: 'seconds'),
      ],
    };

    return data[bmiCategory] ?? data['Normal']!;
  }
}