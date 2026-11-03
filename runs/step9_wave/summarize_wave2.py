"""runs/step9_wave/{stock,wvu}.jsonl → 손흔들기 방식별 표 (step9_improve.md 5절용)"""
import collections, json, re

M = ["v2", "v2low", "traj", "traj3", "angle", "angle3w", "xnorm", "trajB", "angleB"]
# 장면 모음 이미지를 보고 사람이 센 대략의 정답 (손 흔드는 사람·구간 수). None = 평가에서 뺌
TRUTH = {
    "wave_example.webm": (1, "3명 중 왼쪽 1명이 어깨 높이에서 흔듦"),
    "mk33479_waving_two_boys.mp4": (1, "여자아이 1명이 5~13초 흔듦"),
    "mk48998_wave_elderly_couple.mp4": (2, "2명이 내내 흔듦"),
    "mk6389_wave_through_window.mp4": (1, "뒤·옆모습으로 창밖에 흔듦"),
    "mk46150_wave_man_couch.mp4": (1, "2~5초 흔듦"),
    "mk48679_wave_woman_videocall.mp4": (1, "얼굴 가까이, 2~3초 흔듦"),
    "children_waving.webm": (1, "여러 아이, 1회 이상이면 정답"),
    "mk1305_wave_woman_pier.mp4": (None, "드론 영상, 사람이 점처럼 작음 → 제외"),
    "mk48680_waving_woman_greeting.mp4": (None, "얼굴만 나오고 손이 화면 밖 → 제외"),
}
rows = [json.loads(l) for l in open("runs/step9_wave/stock2.jsonl", encoding="utf-8")]
pos = [r for r in rows if r["video"] in TRUTH and TRUTH[r["video"]][0]]
neg = [r for r in rows if r["video"] not in TRUTH]

print("#### 손 흔들기 영상 (양성)")
print("| 영상 | 정답 | " + " | ".join(M) + " |")
print("| --- | --- |" + " --- |" * len(M))
for r in pos:
    print(f"| {r['video']} | {TRUTH[r['video']][0]} ({TRUTH[r['video']][1]}) | " + " | ".join(str(r["wave"][m]) for m in M) + " |")
det = {m: sum(r["wave"][m] > 0 for r in pos) for m in M}
err = {m: sum(abs(r["wave"][m] - TRUTH[r["video"]][0]) for r in pos) for m in M}
print(f"| **검출 ({len(pos)}개 중 1회 이상)** | | " + " | ".join(str(det[m]) for m in M) + " |")
print(f"| **횟수 오차 합** | | " + " | ".join(str(err[m]) for m in M) + " |")
print()
print("#### 손 흔들기가 아닌 영상 (음성, 숫자 = 잘못 센 손흔들기)")
print("| 영상 | " + " | ".join(M) + " |")
print("| --- |" + " --- |" * len(M))
for r in neg:
    print(f"| {r['video']} | " + " | ".join(str(r["wave"][m]) for m in M) + " |")
fp = {m: sum(r["wave"][m] for r in neg) for m in M}
fpv = {m: sum(r["wave"][m] > 0 for r in neg) for m in M}
print(f"| **오판정 합 (오판정 난 영상 수/{len(neg)})** | " + " | ".join(f"{fp[m]} ({fpv[m]})" for m in M) + " |")
print()

V = {"1": "V1 정면", "2": "V2 45도", "3": "V3 측면", "7": "V7 반대 측면"}
agg = collections.defaultdict(collections.Counter)
for l in open("runs/step9_wave/wvu2.jsonl", encoding="utf-8"):
    r = json.loads(l)
    e, s, v = re.search(r"e(\d+)_s(\d+)_v(\d+)", r["video"]).groups()
    grp = "pos" if e in ("4", "5") else "neg"
    for m in M:
        agg[(grp, v)][m] += r["wave"][m] > 0
        agg[(grp, v)][m + "_n"] += r["wave"][m]
print("#### WVU 시점별 (손 흔들기 = 한 손·두 손 흔들기 6개 영상 중 잡은 수, 음성 = 서 있기·박수·팔벌려뛰기 9개 영상의 오판정 수)")
print("| 시점 | 구분 | " + " | ".join(M) + " |")
print("| --- | --- |" + " --- |" * len(M))
for v in V:
    print(f"| {V[v]} | 손 흔들기 검출 /6 | " + " | ".join(str(agg[('pos', v)][m]) for m in M) + " |")
    print(f"| {V[v]} | 음성 오판정 | " + " | ".join(str(agg[('neg', v)][m + '_n']) for m in M) + " |")
tot_p = {m: sum(agg[("pos", v)][m] for v in V) for m in M}
tot_n = {m: sum(agg[("neg", v)][m + "_n"] for v in V) for m in M}
print(f"| 전체 | 손 흔들기 검출 /24 | " + " | ".join(str(tot_p[m]) for m in M) + " |")
print(f"| 전체 | 음성 오판정 | " + " | ".join(str(tot_n[m]) for m in M) + " |")
print()

print("#### v2가 놓친 이유 (양성 영상 진단)")
print("| 영상 | 프레임 | 어깨 안 보임 | 손이 v2 기준 높이 위 | 손목이 팔꿈치 위(흔드는 자세) | v2 창 안 최대 방향 전환 | 어깨/몸통 |")
print("| --- | --- | --- | --- | --- | --- | --- |")
for r in pos:
    d = r["diag"]; n = max(d.get("frames", 0), 1)
    print(f"| {r['video']} | {d.get('frames', 0)} | {d.get('no_shoulders', 0) / n:.0%} | {d.get('v2_high', 0) / n:.0%} | "
          f"{d.get('elbow_up', 0) / n:.0%} | {d.get('v2_max_changes', 0)} | {d.get('sw_torso_median')} |")
