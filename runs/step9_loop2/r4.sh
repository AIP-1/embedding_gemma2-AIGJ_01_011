# 정확도 개선 2차 라운드 4: 규칙 확인을 박수에만 적용 (팔짱은 GRU+문지기+확률 차이+연속 투표)
cd ~/eg2-lab
W=media/pose/wvu; M=media/pose/mixkit; P=media/pose
NEG="$P/jumping_jacks_burpees.webm $M/mk35968_classroom_raise_hands_b.mp4 $M/mk11553_raise_hand_question.mp4 media/samples/vtest.avi $W/e8_s3_v1.avi $W/e8_s3_v3.avi $M/mk29963_arms_crossed_woman_livingroom.mp4 $P/applause_wikiconvention.webm $P/wave_example.webm $M/mk50643_arms_crossed_model.mp4 $M/mk24214_clap_conference.mp4 $P/handshake_tv.ogv"
B="--model models/action_r2m.pt --gate-model models/action_l2r1.pt --gate-th 0.5 --ml-only arms_crossed,clap --ml-margin 0.3"
APP_ARGS="$B --ml-vote 3 --ml-rule --ml-rule-labels clap" bash runs/step9_hs/live_repro.sh pose_app_v6.py runs/step9_loop2/r4_live_clapRule.jsonl $NEG
echo R4DONE
