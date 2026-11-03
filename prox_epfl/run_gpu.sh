# 재부팅(16:07) 뒤 GPU로 남은 알람 실험(stereo, fused)과 ankle1 재측정 속도
cd ~/eg2-lab/prox_epfl && source ~/eg2/bin/activate
python -c "import torch; print('cuda', torch.cuda.is_available())"
for m in stereo fused ankle1; do
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 1200 ] && { echo "LOWMEM $a skip $m"; continue; }
  python prox_epfl.py --mode alarm --method $m --json results.jsonl 2>&1 | grep -v -e WARN -e half
done
echo ALLDONE
