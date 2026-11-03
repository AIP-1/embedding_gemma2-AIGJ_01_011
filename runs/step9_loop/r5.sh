# 라운드 5: 실제 앱(15fps 안팎)에서 GRU(--model) 오판정 측정. 손흔들기는 규칙, GRU는 팔짱·박수 확인용
cd ~/eg2-lab
P=media/pose; M=$P/mixkit
APP_ARGS="--model models/action_r2m.pt" bash runs/step9_hs/live_repro.sh pose_app_v4.py runs/step9_loop/r5_live_r2m.jsonl \
  $M/mk29963_arms_crossed_woman_livingroom.mp4 $P/applause_wikiconvention.webm $P/jumping_jacks_burpees.webm $P/handshake_tv.ogv \
  $M/mk35968_classroom_raise_hands_b.mp4 media/samples/vtest.avi $P/wave_example.webm
echo R5DONE
