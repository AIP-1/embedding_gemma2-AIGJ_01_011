cd ~/eg2-lab && source ~/eg2/bin/activate
P=media/pose; M=$P/mixkit
ALL="$P/handshake_tv.ogv $M/mk49419_hs_yacht.mp4 $M/mk23387_hs_after_negotiation.mp4 $M/mk25253_hs_welcoming_partner.mp4 $M/mk23085_clap_office.mp4 $M/mk36153_clap_standing_meeting.mp4 $M/mk5953_clap_seminar.mp4 $P/applause_wikiconvention.webm $M/mk24214_clap_conference.mp4 $M/mk48667_clap_group_therapy.mp4 $M/mk48998_wave_elderly_couple.mp4 $P/wave_example.webm $P/children_waving.webm $M/mk35968_classroom_raise_hands_b.mp4 $M/mk4519_idle_students_walking.mp4 media/samples/vtest.avi"
for st in 1 2; do for v in $ALL; do
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 800 ] && { echo "LOWMEM $a skip $v"; continue; }
  python pose_eval_v4.py $v --stride $st --json runs/step9_hs/hs3_s$st.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-220
done; done
echo ALLDONE
