cd ~/eg2-lab && source ~/eg2/bin/activate
for v in jumping_jack_slow.webm jumping_jacks_burpees.webm handshake_sts71.ogv handshake_tv.ogv applause_wikiconvention.webm clapping_nhs.webm; do
  python pose_eval.py media/pose/$v --model models/action.pt --out runs/step9_extra/${v%.*}.md 2>&1 | grep -v half
done
echo ALLDONE
