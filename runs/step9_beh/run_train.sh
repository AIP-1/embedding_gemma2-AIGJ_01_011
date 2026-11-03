# 9-6 행동 모델: 영상 단위로 학습/테스트를 나눠 train_pose.py --task behavior로 학습
cd ~/eg2-lab && source ~/eg2/bin/activate
M=media/pose/mixkit
X(){ python extract_feats.py "$@" 2>&1 | grep -v -e half -e WARN | grep "→"; }
mkdir -p data/behavior_v1 data/behavior_test_v1
X --label passing --out data/behavior_v1/passing.csv $M/mk4519_idle_students_walking.mp4 $M/mk25890_idle_people_walking.mp4
X --label linger --out data/behavior_v1/linger.csv $M/mk46711_idle_standing_man_rain.mp4 $M/mk28329_idle_students_wall.mp4
X --label interested --out data/behavior_v1/interested.csv $M/mk28302_arms_crossed_man_green.mp4 $M/mk11653_arms_crossed_woman_standing.mp4 $M/mk43822_clap_proud_man.mp4
X --label passing --out data/behavior_test_v1/passing.csv media/samples/vtest.avi
X --label linger --out data/behavior_test_v1/linger.csv $M/mk460_idle_standing_woman.mp4
X --label interested --out data/behavior_test_v1/interested.csv $M/mk29963_arms_crossed_woman_livingroom.mp4 $M/mk48998_wave_elderly_couple.mp4
wc -l data/behavior_v1/*.csv data/behavior_test_v1/*.csv
python train_pose.py --data data/behavior_v1 --task behavior --window 80 --stride 10 --out models/behavior_v1.pt 2>&1 | tail -12
python eval_gru.py --data data/behavior_test_v1 --stride 10 models/behavior_v1.pt 2>/dev/null | grep -E "^###|^\|"
for v in media/samples/vtest.avi $M/mk460_idle_standing_woman.mp4 $M/mk29963_arms_crossed_woman_livingroom.mp4 $M/mk48998_wave_elderly_couple.mp4; do
  python pose_eval_beh.py $v --model models/behavior_v1.pt --json runs/step9_beh/model.jsonl 2>&1 | grep -v -e WARN -e half | tail -1 | cut -c1-220
done
echo ALLDONE
