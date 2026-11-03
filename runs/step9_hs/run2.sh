cd ~/eg2-lab && source ~/eg2/bin/activate
P=media/pose; M=$P/mixkit; W=$P/wvu
ALL="$P/handshake_tv.ogv $M/mk23387_hs_after_negotiation.mp4 $M/mk25253_hs_welcoming_partner.mp4 $M/mk30011_hs_silhouettes.mp4 $M/mk49419_hs_yacht.mp4 $M/mk48998_wave_elderly_couple.mp4 $P/wave_example.webm $M/mk33479_waving_two_boys.mp4 $P/children_waving.webm $P/applause_wikiconvention.webm $M/mk24214_clap_conference.mp4 $M/mk23085_clap_office.mp4 $M/mk35954_classroom_raise_hands_a.mp4 $M/mk35968_classroom_raise_hands_b.mp4 $M/mk4519_idle_students_walking.mp4 media/samples/vtest.avi $M/mk100320_wave_friends_indoors.mp4 $M/mk48999_wave_santas.mp4"
for st in 1 2; do for v in $ALL; do
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 800 ] && { echo "LOWMEM $a skip $v"; continue; }
  python pose_eval_v4.py $v --stride $st --json runs/step9_hs/hs2_s$st.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-200
done; done
echo ALLDONE
