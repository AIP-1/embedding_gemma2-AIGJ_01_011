cd ~/eg2-lab && source ~/eg2/bin/activate
W=media/pose/wvu
X(){ python extract_feats.py "$@" 2>&1 | grep -v -e half -e WARN | tail -1; }
# 학습: 사람 1·2, 모든 시점
X --label idle --out data/action_v5/idle.csv $W/e1_s1_v*.avi $W/e1_s2_v*.avi
X --label clap --out data/action_v5/clap.csv $W/e3_s1_v*.avi $W/e3_s2_v*.avi
X --label wave --out data/action_v5/wave.csv $W/e4_s1_v*.avi $W/e4_s2_v*.avi $W/e5_s1_v*.avi $W/e5_s2_v*.avi
# 테스트: 사람 3, 시점별
for v in 1 2 3 7; do mkdir -p data/action_test_wvu/v$v
  X --label idle --out data/action_test_wvu/v$v/idle.csv $W/e1_s3_v$v.avi
  X --label clap --out data/action_test_wvu/v$v/clap.csv $W/e3_s3_v$v.avi
  X --label wave --out data/action_test_wvu/v$v/wave.csv $W/e4_s3_v$v.avi $W/e5_s3_v$v.avi
done
python train_pose_v2.py --data data/action_v5 --task action --window 30 --mirror --out models/action_v5m.pt > train_v5m_pose.log 2>&1
for v in 1 2 3 7; do echo "=== 시점 V$v (사람 3)"; python eval_gru.py --data data/action_test_wvu/v$v models/action.pt models/action_v3m.pt models/action_v5m.pt 2>/dev/null | grep -E "^###|^\| (전체|clap|idle|wave)"; done
echo ALLDONE
