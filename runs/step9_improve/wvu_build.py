"""WVU 장면 사진(frames/e<동작>/train<사람>_view<시점>_<번호>.jpg)을 20fps MJPG avi로 묶는다.
출력: media/pose/wvu/e<동작>_s<사람>_v<시점>.avi
"""
import collections, glob, os, re
import cv2

ROOT = os.path.expanduser("~/eg2-lab/media/pose/wvu")
groups = collections.defaultdict(list)
for p in glob.glob(f"{ROOT}/frames/e*/*.jpg"):
    m = re.search(r"/e(\d+)/train(\d+)_view(\d+)_(\d+)\.jpg$", p)
    if m:
        e, s, v, n = map(int, m.groups())
        groups[(e, s, v)].append((n, p))
for (e, s, v), fs in sorted(groups.items()):
    out = f"{ROOT}/e{e}_s{s}_v{v}.avi"
    if os.path.exists(out):
        continue
    fs.sort()
    h, w = cv2.imread(fs[0][1]).shape[:2]
    vw = cv2.VideoWriter(out, cv2.VideoWriter_fourcc(*"MJPG"), 20, (w, h))
    for _, p in fs:
        vw.write(cv2.imread(p))
    vw.release()
    print(os.path.basename(out), len(fs), "frames")
