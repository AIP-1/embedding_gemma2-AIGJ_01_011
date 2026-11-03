cd ~/eg2-lab && source ~/eg2/bin/activate
for v in media/pose/mixkit/*.mp4; do
  b=$(basename $v .mp4)
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 800 ] && { echo "LOWMEM $a, skip $b"; continue; }
  python pose_eval.py $v --model models/action.pt --out runs/step9_extra2/$b.md 2>&1 | grep -v -e half -e "^saved"
done
echo ALLDONE
