# 두 번째 타깃 (2.8, 0.8): 정답 기준 0.8m 안에 사람이 있는 시간 50%, 진입 18회
cd ~/eg2-lab/prox_epfl && source ~/eg2/bin/activate
for m in ankle1 stereo fused; do
  python prox_epfl.py --mode alarm --method $m --target-xy 2.8,0.8 --json results.jsonl 2>&1 | grep -v -e WARN -e half -e NvRm
done
echo ALLDONE
