cd ~/eg2-lab && source ~/eg2/bin/activate
P=media/pose; M=$P/mixkit
ALL="$P/wave_example.webm $P/children_waving.webm $P/raise_hand.webm $P/jumping_jacks_burpees.webm $P/handshake_tv.ogv $P/applause_wikiconvention.webm $P/clapping_nhs.webm $M/mk28302_arms_crossed_man_green.mp4 $M/mk11653_arms_crossed_woman_standing.mp4 $M/mk29963_arms_crossed_woman_livingroom.mp4 $M/mk50643_arms_crossed_model.mp4 $M/mk35954_classroom_raise_hands_a.mp4 $M/mk35968_classroom_raise_hands_b.mp4 $M/mk11553_raise_hand_question.mp4 $M/mk33479_waving_two_boys.mp4 $M/mk48998_wave_elderly_couple.mp4 $M/mk6389_wave_through_window.mp4 media/samples/vtest.avi"
LOW="$P/wave_example.webm $P/children_waving.webm $M/mk33479_waving_two_boys.mp4 $M/mk48998_wave_elderly_couple.mp4 $M/mk6389_wave_through_window.mp4 $M/mk28302_arms_crossed_man_green.mp4 $M/mk29963_arms_crossed_woman_livingroom.mp4 $P/clapping_nhs.webm $M/mk24214_clap_conference.mp4 media/samples/vtest.avi"
for v in $ALL; do
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 800 ] && { echo "LOWMEM $a skip $v"; continue; }
  python pose_eval_v2.py $v --models models/action.pt models/action_v3m.pt --json runs/step9_improve/v2.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-200
done
for v in $LOW; do
  python pose_eval_v2.py $v --low-wave --models --json runs/step9_improve/v2_lowwave.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-200
done
echo ALLDONE
