cd ~/eg2-lab && source ~/eg2/bin/activate
W=media/pose/wvu
for e in 1 3 4 5 8; do
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 800 ] && { echo "LOWMEM $a skip e$e"; continue; }
  python pose_eval_v2.py $W/e${e}_s*_v*.avi --models models/action.pt models/action_v3m.pt --json runs/step9_improve/wvu.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-120
done
for e in 1 3 4 5; do
  python pose_eval_v2.py $W/e${e}_s*_v*.avi --low-wave --models --json runs/step9_improve/wvu_lowwave.jsonl 2>&1 | grep -v -e half -e WARN | cut -c1-120
done
python runs/step9_improve/wvu_view.py > runs/step9_improve/wvu_view.jsonl 2>/dev/null
echo ALLDONE
