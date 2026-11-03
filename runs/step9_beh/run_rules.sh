# 9-5: pose_app.py --behavior와 같은 규칙으로 영상별 행동 판정
cd ~/eg2-lab && source ~/eg2/bin/activate
M=media/pose/mixkit; P=media/pose
for v in media/samples/vtest.avi $M/mk4519_idle_students_walking.mp4 $M/mk25890_idle_people_walking.mp4 $M/mk460_idle_standing_woman.mp4 $M/mk46711_idle_standing_man_rain.mp4 $M/mk28329_idle_students_wall.mp4 $M/mk28302_arms_crossed_man_green.mp4 $M/mk29963_arms_crossed_woman_livingroom.mp4 $M/mk11653_arms_crossed_woman_standing.mp4 $M/mk43822_clap_proud_man.mp4 $P/wave_example.webm $M/mk48998_wave_elderly_couple.mp4 $P/wvu/e1_s3_v1.avi; do
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 1200 ] && { echo "LOWMEM $a skip $v"; continue; }
  python pose_eval_beh.py $v --json runs/step9_beh/rules.jsonl 2>&1 | grep -v -e WARN -e half | tail -1 | cut -c1-200
done
echo ALLDONE
