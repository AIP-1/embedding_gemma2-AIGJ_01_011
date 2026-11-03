"""라운드 4: 이어지는 영상에서 GRU 단독 vs 결합(손 흔들기=규칙 angleC, 팔짱·박수=GRU) 비교 표
입력: runs/step9_loop/r4_stream.jsonl (pose_eval_v2.py --models action_r2m.pt action_v6u.pt)
      runs/step9_wave/stock3.jsonl, wvu3.jsonl (pose_eval_v3.py, 규칙 angleC 손흔들기 횟수)
"""
import json

TRUTH = {  # 영상별 기대 동작 (GRU 4동작 기준)
    "mk29963_arms_crossed_woman_livingroom.mp4": "arms_crossed", "mk50643_arms_crossed_model.mp4": "arms_crossed",
    "applause_wikiconvention.webm": "clap", "clapping_nhs.webm": "clap(학습에 씀)", "mk24214_clap_conference.mp4": "clap(학습에 씀)",
    "e3_s3_v1.avi": "clap", "e3_s3_v3.avi": "clap",
    "wave_example.webm": "wave", "wave_couch_2-5.5s.avi": "wave", "mk48998_wave_elderly_couple.mp4": "wave",
    "children_waving.webm": "wave", "e4_s3_v1.avi": "wave", "e4_s3_v3.avi": "wave",
}
rule = {}
for f in ("runs/step9_wave/stock3.jsonl", "runs/step9_wave/wvu3.jsonl"):
    for l in open(f, encoding="utf-8"):
        r = json.loads(l); rule[r["video"]] = r["wave"]["angleC"]
fmt = lambda c: ", ".join(f"{k} {v}" for k, v in sorted(c.items())) or "0"
print("| 영상 | 기대 | GRU r2m 단독 (@0.7) | GRU v6u 단독 (@0.7) | 결합: 팔짱·박수=r2m, 손 흔들기=규칙 angleC |")
print("| --- | --- | --- | --- | --- |")
tot = {"r2m_fp": 0, "v6u_fp": 0, "fus_fp": 0}
for l in open("runs/step9_loop/r4_stream.jsonl", encoding="utf-8"):
    r = json.loads(l); v = r["video"]; c = r["counts"]
    g1 = c.get("action_r2m.pt@0.7", {}); g2 = c.get("action_v6u.pt@0.7", {})
    fus = {k: n for k, n in g1.items() if k in ("arms_crossed", "clap")}
    w = rule.get(v, rule.get("mk46150_wave_man_couch.mp4") if v.startswith("wave_couch") else None)
    if w:
        fus["wave(규칙)"] = w
    exp = TRUTH.get(v, "idle(4동작 아님)")
    def fp(cnt):
        return sum(n for k, n in cnt.items() if not exp.startswith(k.split("(")[0]))
    tot["r2m_fp"] += fp(g1); tot["v6u_fp"] += fp(g2); tot["fus_fp"] += fp(fus)
    print(f"| {v} | {exp} | {fmt(g1)} | {fmt(g2)} | {fmt(fus)} |")
print(f"| **기대와 다른 판정 합** | | {tot['r2m_fp']} | {tot['v6u_fp']} | {tot['fus_fp']} |")
