"""runs/step9_improve/*.jsonl → 마크다운 표 (step9_improve.md에 붙일 부분)"""
import json, sys

ACT = ["한팔들기", "만세", "손흔들기", "악수"]
GRU = ["arms_crossed", "clap", "wave"]
TRUTH = {  # 장면 모음 이미지로 확인한 대략의 정답 (사람이 직접 센 값)
    "handshake_tv.ogv": "악수 약 4~6 (0~20초 영접 장면)",
    "jumping_jacks_burpees.webm": "팔 올림 점프 약 6~8 (정면 0~21초 + 측면 22~45초)",
    "wave_example.webm": "손흔들기 1 (어깨 높이)",
    "mk33479_waving_two_boys.mp4": "손흔들기 2 (두 명)",
    "mk28302_arms_crossed_man_green.mp4": "동작 0 (팔짱만)",
    "mk11653_arms_crossed_woman_standing.mp4": "동작 0 (팔짱만)",
    "mk29963_arms_crossed_woman_livingroom.mp4": "동작 0 (팔짱만)",
    "vtest.avi": "동작 0 (걷는 사람들)",
    "applause_wikiconvention.webm": "악수 0 (청중 박수)",
    "clapping_nhs.webm": "동작 0 (박수)",
}
TRAIN = {"mk28302_arms_crossed_man_green.mp4", "mk11653_arms_crossed_woman_standing.mp4", "clapping_nhs.webm",
         "mk33479_waving_two_boys.mp4"}   # action_v3m.pt 학습 영상

def fmt(c, keys):
    s = ", ".join(f"{k} {c[k]}" for k in keys if c.get(k))
    return s or "0"

rows = [json.loads(l) for l in open(sys.argv[1], encoding="utf-8")]
low = {}
if len(sys.argv) > 2:
    low = {r["video"]: r for r in (json.loads(l) for l in open(sys.argv[2], encoding="utf-8"))}

print("| 영상 | 대략의 정답 | 규칙 v1 | 규칙 v2 | v2 + 어깨 높이 흔들기 |")
print("| --- | --- | --- | --- | --- |")
for r in rows:
    c = r["counts"]; v = r["video"]
    lw = fmt(low[v]["counts"]["v2"], ACT) if v in low else "-"
    print(f"| {v} | {TRUTH.get(v, '-')} | {fmt(c['v1'], ACT)} ({sum(c['v1'].values())}) | "
          f"{fmt(c['v2'], ACT)} ({sum(c['v2'].values())}) | {lw} |")
print()
print("| 영상 | 학습에 씀 | action.pt @0.7 | action_v3m.pt @0.7 | action.pt @0.5 | action_v3m.pt @0.5 |")
print("| --- | --- | --- | --- | --- | --- |")
for r in rows:
    c = r["counts"]; v = r["video"]
    print(f"| {v} | {'예' if v in TRAIN else ''} | {fmt(c['action.pt@0.7'], GRU)} | {fmt(c['action_v3m.pt@0.7'], GRU)} | "
          f"{fmt(c['action.pt@0.5'], GRU)} | {fmt(c['action_v3m.pt@0.5'], GRU)} |")
