# 정확도 개선 2차 라운드 1: "그 밖의 움직임(other)" 클래스 추가
cd ~/eg2-lab && source ~/eg2/bin/activate
W=media/pose/wvu; M=media/pose/mixkit; P=media/pose
python runs/step9_improve/wvu_build.py | tail -2
X(){ python extract_feats.py "$@" 2>&1 | grep -v -e half -e WARN | grep "→" | tail -3; }
mkdir -p data/action_l2r1 data/action_test_l2
for l in arms_crossed clap idle wave; do cp -p data/action_r2/$l.csv data/action_l2r1/; cp -p data/action_test_v7/$l.csv data/action_test_l2/; done
TR=""; TE=""
for e in 2 6 7 9 10 11 12; do for v in 1 2 3 7; do
  for s in 1 2; do test -e $W/e${e}_s${s}_v$v.avi && TR="$TR $W/e${e}_s${s}_v$v.avi"; done
  test -e $W/e${e}_s3_v$v.avi && TE="$TE $W/e${e}_s3_v$v.avi"
done; done
X --label other --out data/action_l2r1/other.csv $TR $M/mk*_other_*.mp4
X --label other --out data/action_test_l2/other.csv $TE
wc -l data/action_l2r1/*.csv data/action_test_l2/*.csv
python train_pose_v4.py --data data/action_l2r1 --task action --window 30 --mirror --out models/action_l2r1.pt > runs/step9_loop2/train_l2r1.log 2>&1; tail -9 runs/step9_loop2/train_l2r1.log
echo "=== 스톡+other 테스트"; python eval_gru.py --data data/action_test_l2 models/action_r2m.pt models/action_l2r1.pt 2>/dev/null | grep -E "^###|^\| (전체|arms|clap|idle|wave|other)"
for v in 1 2 3 7; do echo "=== WVU V$v"; python eval_gru.py --data data/action_test_wvu/v$v models/action_r2m.pt models/action_l2r1.pt 2>/dev/null | grep -E "^\| 전체"; done
echo R1TRAINDONE
NEG="$P/jumping_jacks_burpees.webm $M/mk35968_classroom_raise_hands_b.mp4 $M/mk11553_raise_hand_question.mp4 media/samples/vtest.avi $W/e8_s3_v1.avi $W/e8_s3_v3.avi $M/mk29963_arms_crossed_woman_livingroom.mp4 $P/applause_wikiconvention.webm $P/wave_example.webm"
APP_ARGS="--model models/action_r2m.pt" bash runs/step9_hs/live_repro.sh pose_app_v5.py runs/step9_loop2/r1_live_r2m.jsonl $NEG
APP_ARGS="--model models/action_l2r1.pt" bash runs/step9_hs/live_repro.sh pose_app_v5.py runs/step9_loop2/r1_live_l2r1.jsonl $NEG
bash runs/step9_hs/live_repro.sh pose_app_v5.py runs/step9_loop2/r1_live_rules.jsonl $NEG
echo R1DONE
