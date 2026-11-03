# 정확도 개선 2차 라운드 2: 2단계(문지기 l2r1 + 동작 종류 r2m), 판정 거부·라벨 제한·규칙 확인
cd ~/eg2-lab
W=media/pose/wvu; M=media/pose/mixkit; P=media/pose
NEG="$P/jumping_jacks_burpees.webm $M/mk35968_classroom_raise_hands_b.mp4 $M/mk11553_raise_hand_question.mp4 media/samples/vtest.avi $W/e8_s3_v1.avi $W/e8_s3_v3.avi $M/mk29963_arms_crossed_woman_livingroom.mp4 $P/applause_wikiconvention.webm $P/wave_example.webm"
APP_ARGS="--model models/action_r2m.pt --gate-model models/action_l2r1.pt --gate-th 0.5" bash runs/step9_hs/live_repro.sh pose_app_v6.py runs/step9_loop2/r2_live_gate.jsonl $NEG
APP_ARGS="--model models/action_r2m.pt --gate-model models/action_l2r1.pt --gate-th 0.5 --ml-only arms_crossed,clap --ml-margin 0.3 --ml-vote 3 --ml-rule" bash runs/step9_hs/live_repro.sh pose_app_v6.py runs/step9_loop2/r2_live_gate_strict.jsonl $NEG
echo R2DONE
