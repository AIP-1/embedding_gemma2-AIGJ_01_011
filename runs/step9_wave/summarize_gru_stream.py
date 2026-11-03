"""runs/step9_wave/gru_stream.jsonl → 이어지는 영상에서 GRU 판정 횟수 표"""
import json

T = {"mk29963_arms_crossed_woman_livingroom.mp4": "arms_crossed", "applause_wikiconvention.webm": "clap", "mk46150_wave_man_couch.mp4": "wave 1", "mk48679_wave_woman_videocall.mp4": "wave 1", "wave_example.webm": "wave 1"}
MODELS = ["action_v3m.pt", "action_v5m.pt", "action_v6m.pt"]
f = lambda c: ", ".join(f"{k} {v}" for k, v in c.items()) or "0"
print("| 영상 | 정답 | " + " | ".join(f"{m} @0.7" for m in MODELS) + " |")
print("| --- | --- |" + " --- |" * len(MODELS))
for l in open("runs/step9_wave/gru_stream.jsonl", encoding="utf-8"):
    r = json.loads(l); c = r["counts"]
    print(f"| {r['video']} | {T.get(r['video'], 'idle(4동작 아님)')} | " + " | ".join(f(c[f'{m}@0.7']) for m in MODELS) + " |")
