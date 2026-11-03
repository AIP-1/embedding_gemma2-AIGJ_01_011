cd ~/eg2-lab && source ~/eg2/bin/activate
T=media/pose/test_clips
mkdir -p data/action_test_v7
for l in arms_crossed clap idle; do cp -p data/action_test_v6/$l.csv data/action_test_v7/; done
python extract_feats.py --label wave --out data/action_test_v7/wave.csv media/pose/wave_example.webm $T/wave_couch_2-5.5s.avi $T/wave_videocall_1.5-4s.avi 2>&1 | grep "→"
wc -l data/action_test_v7/*.csv
python eval_gru.py --data data/action_test_v7 models/action_v3m.pt models/action_v5m.pt models/action_v6m.pt models/action_v6u.pt models/action_r1_ld.pt models/action_r2m.pt models/action_r2m_ld.pt 2>/dev/null | grep -E "^###|^\| (전체|arms|clap|idle|wave)"
echo ALLDONE
