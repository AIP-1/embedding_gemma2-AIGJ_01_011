"""WVU 영상에서 시점별로 어깨 너비(코 높이~엉덩이 높이 대비)와 관절 검출률을 잰다 (README 9-2: 측면이면 어깨 너비가 줄어 기준이 흔들림).
결과: 동작·시점별 평균 '어깨 너비 / 몸통 길이', 어깨 둘 다 보인 프레임 비율, 손목 올림(규칙 기준) 프레임 비율
"""
import collections, glob, json, os, re
import cv2, numpy as np
from ultralytics import YOLO
from pose_model import KP_CONF, LS, RS, LW, RW, LH, RH

det = YOLO("yolo11n-pose.pt")
stat = collections.defaultdict(lambda: {"n": 0, "sh": 0, "ratio": [], "up": 0})
for p in sorted(glob.glob(os.path.expanduser("~/eg2-lab/media/pose/wvu/e*_s*_v*.avi"))):
    e, s, v = map(int, re.search(r"e(\d+)_s(\d+)_v(\d+)", p).groups())
    cap = cv2.VideoCapture(p)
    while True:
        ok, fr = cap.read()
        if not ok:
            break
        r = det(fr, conf=0.5, verbose=False)[0]
        st = stat[(e, v)]; st["n"] += 1
        if r.keypoints is None or not len(r.boxes):
            continue
        k = np.concatenate([r.keypoints.xy.cpu().numpy(), r.keypoints.conf.cpu().numpy()[..., None]], -1)[0]
        if k[LS, 2] < KP_CONF or k[RS, 2] < KP_CONF:
            continue
        st["sh"] += 1
        torso = abs((k[LH, 1] + k[RH, 1]) / 2 - (k[LS, 1] + k[RS, 1]) / 2)
        if k[LH, 2] > KP_CONF and k[RH, 2] > KP_CONF and torso > 10:
            st["ratio"].append(abs(k[LS, 0] - k[RS, 0]) / torso)
        cy, sw = (k[LS, 1] + k[RS, 1]) / 2, max(abs(k[LS, 0] - k[RS, 0]), 20.0)
        if any(k[w, 2] > KP_CONF and k[w, 1] < cy - 0.3 * sw for w in (LW, RW)):
            st["up"] += 1
for (e, v), st in sorted(stat.items()):
    print(json.dumps({"event": e, "view": v, "frames": st["n"], "shoulders": round(st["sh"] / max(st["n"], 1), 2),
                      "sw_torso": round(float(np.median(st["ratio"])), 2) if st["ratio"] else None,
                      "wrist_up": round(st["up"] / max(st["n"], 1), 2)}))
