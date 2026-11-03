# 10단계 EPFL 재현: 정답 프레임 위치 비교 → 방식별 알람 비교 (영상마다가 아니라 방식마다 한 프로세스)
cd ~/eg2-lab/prox_epfl && source ~/eg2/bin/activate
until grep -q DLDONE ../media/prox_epfl/dl6.log 2>/dev/null; do sleep 30; done
cp -n ../media/prox_epfl/calibration-6p.txt . 2>/dev/null; ls -l ../media/prox_epfl/6p-c*.avi ../media/prox_epfl/gt_lab_6p.txt
python -c "import cv2; c=cv2.VideoCapture(\"../media/prox_epfl/6p-c0.avi\"); print(\"frames\", c.get(7), \"fps\", c.get(5), \"size\", c.get(3), c.get(4))"
a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); echo "avail $a"
python prox_epfl.py --mode eval --json results.jsonl 2>&1 | grep -v -e WARN -e half
for m in ankle1 stereo fused; do
  a=$(free -m | awk "/^메모리|^Mem/{print \$7}"); [ "$a" -lt 1200 ] && { echo "LOWMEM $a skip $m"; continue; }
  python prox_epfl.py --mode alarm --method $m --json results.jsonl 2>&1 | grep -v -e WARN -e half
done
echo ALLDONE
