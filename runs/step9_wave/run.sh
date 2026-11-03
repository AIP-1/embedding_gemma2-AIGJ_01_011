cd ~/eg2-lab && source ~/eg2/bin/activate
P=media/pose; M=$P/mixkit; W=$P/wvu
POS="$P/wave_example.webm $M/mk33479_waving_two_boys.mp4 $M/mk48998_wave_elderly_couple.mp4 $M/mk6389_wave_through_window.mp4 $M/mk46150_wave_man_couch.mp4 $M/mk48679_wave_woman_videocall.mp4 $M/mk1305_wave_woman_pier.mp4 $M/mk48680_waving_woman_greeting.mp4 $P/children_waving.webm"
NEG="$M/mk28302_arms_crossed_man_green.mp4 $M/mk11653_arms_crossed_woman_standing.mp4 $M/mk29963_arms_crossed_woman_livingroom.mp4 $M/mk50643_arms_crossed_model.mp4 $P/clapping_nhs.webm $P/applause_wikiconvention.webm $M/mk23085_clap_office.mp4 $M/mk48667_clap_group_therapy.mp4 $M/mk5953_clap_seminar.mp4 $M/mk24214_clap_conference.mp4 $M/mk4519_idle_students_walking.mp4 $M/mk460_idle_standing_woman.mp4 media/samples/vtest.avi $M/mk35954_classroom_raise_hands_a.mp4 $M/mk35968_classroom_raise_hands_b.mp4 $M/mk11553_raise_hand_question.mp4 $P/jumping_jacks_burpees.webm $P/handshake_tv.ogv"
for v in $POS $NEG; do
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 800 ] && { echo "LOWMEM $a skip $v"; continue; }
  python pose_eval_v3.py $v --json runs/step9_wave/stock2.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-160
done
for e in 4 5 1 3 8; do python pose_eval_v3.py $W/e${e}_s*_v*.avi --json runs/step9_wave/wvu2.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-120; done
echo ALLDONE
