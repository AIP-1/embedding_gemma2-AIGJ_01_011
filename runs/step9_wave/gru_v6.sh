cd ~/eg2-lab && source ~/eg2/bin/activate
P=media/pose; M=$P/mixkit; W=$P/wvu
X(){ python extract_feats.py "$@" 2>&1 | grep -v -e half -e WARN | tail -1; }
mkdir -p data/action_v6 data/action_test_v6
for l in arms_crossed clap idle wave; do cp -p data/action_v3/$l.csv data/action_v6/; done
cp -p data/action_test/arms_crossed.csv data/action_test/clap.csv data/action_test/idle.csv data/action_test/wave.csv data/action_test_v6/
# 학습 추가: 손 흔들기(Mixkit 2 + WVU 사람1·2), 박수(WVU 사람1·2), 그 밖의 움직임→idle(WVU 서 있기·팔벌려뛰기 사람1·2, 악수 TV, 교실 손 들기)
X --label wave --out data/action_v6/wave.csv $M/mk48998_wave_elderly_couple.mp4 $M/mk6389_wave_through_window.mp4 $W/e4_s1_v*.avi $W/e4_s2_v*.avi $W/e5_s1_v*.avi $W/e5_s2_v*.avi
X --label clap --out data/action_v6/clap.csv $W/e3_s1_v*.avi $W/e3_s2_v*.avi
X --label idle --out data/action_v6/idle.csv $W/e1_s1_v*.avi $W/e1_s2_v*.avi $W/e8_s1_v*.avi $W/e8_s2_v*.avi $P/handshake_tv.ogv $M/mk35954_classroom_raise_hands_a.mp4
# 테스트 추가: 손 흔들기 2개(학습에 안 씀)
X --label wave --out data/action_test_v6/wave.csv $M/mk46150_wave_man_couch.mp4 $M/mk48679_wave_woman_videocall.mp4
wc -l data/action_v6/*.csv data/action_test_v6/*.csv
python train_pose_v2.py --data data/action_v6 --task action --window 30 --mirror --out models/action_v6m.pt > train_v6m_pose.log 2>&1; tail -8 train_v6m_pose.log
echo "=== 스톡 테스트(손 흔들기 3개 영상)"; python eval_gru.py --data data/action_test_v6 models/action_v3m.pt models/action_v5m.pt models/action_v6m.pt 2>/dev/null | grep -E "^###|^\| (전체|arms|clap|idle|wave)"
for v in 1 2 3 7; do echo "=== WVU 사람3 V$v"; python eval_gru.py --data data/action_test_wvu/v$v models/action_v3m.pt models/action_v5m.pt models/action_v6m.pt 2>/dev/null | grep -E "^###|^\| 전체"; done
# 연속 영상 오판정: 음성 영상에서 GRU 판정 횟수
for v in $M/mk29963_arms_crossed_woman_livingroom.mp4 $P/applause_wikiconvention.webm media/samples/vtest.avi $M/mk35968_classroom_raise_hands_b.mp4 $M/mk11553_raise_hand_question.mp4 $P/jumping_jacks_burpees.webm $W/e8_s3_v1.avi $W/e8_s3_v3.avi $M/mk46150_wave_man_couch.mp4 $M/mk48679_wave_woman_videocall.mp4 $P/wave_example.webm; do
  python pose_eval_v2.py $v --models models/action_v3m.pt models/action_v5m.pt models/action_v6m.pt --json runs/step9_wave/gru_stream.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-80
done
echo ALLDONE
