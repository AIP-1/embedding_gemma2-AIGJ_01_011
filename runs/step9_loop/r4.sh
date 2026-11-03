cd ~/eg2-lab && source ~/eg2/bin/activate
P=media/pose; M=$P/mixkit; T=$P/test_clips
for v in $M/mk29963_arms_crossed_woman_livingroom.mp4 $M/mk50643_arms_crossed_model.mp4 $P/applause_wikiconvention.webm $P/clapping_nhs.webm $M/mk24214_clap_conference.mp4 media/samples/vtest.avi $M/mk4519_idle_students_walking.mp4 $M/mk460_idle_standing_woman.mp4 $M/mk35954_classroom_raise_hands_a.mp4 $M/mk35968_classroom_raise_hands_b.mp4 $M/mk11553_raise_hand_question.mp4 $P/jumping_jacks_burpees.webm $P/handshake_tv.ogv $P/wave_example.webm $T/wave_couch_2-5.5s.avi $M/mk48998_wave_elderly_couple.mp4 $P/children_waving.webm $P/wvu/e1_s3_v1.avi $P/wvu/e1_s3_v3.avi $P/wvu/e3_s3_v1.avi $P/wvu/e3_s3_v3.avi $P/wvu/e4_s3_v1.avi $P/wvu/e4_s3_v3.avi; do
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 800 ] && { echo "LOWMEM $a skip $v"; continue; }
  python pose_eval_v2.py $v --models models/action_r2m.pt models/action_v6u.pt --json runs/step9_loop/r4_stream.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-100
done
echo ALLDONE
