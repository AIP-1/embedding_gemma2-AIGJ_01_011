"""WVU 결과(jsonl)를 동작 × 시점 표로 합친다. 값은 사람 3명 합계."""
import collections, json, re, sys

EV = {1: "가만히 서 있기", 3: "박수", 4: "한 손 흔들기", 5: "두 손 흔들기", 8: "팔벌려뛰기"}
VIEW = {1: "V1 정면", 2: "V2 45도", 3: "V3 측면", 7: "V7 반대 측면"}
EXPECT = {1: "0", 3: "규칙 0 / GRU clap", 4: "손흔들기 3", 5: "손흔들기 또는 만세 3", 8: "만세 여러 번"}
agg = collections.defaultdict(lambda: collections.defaultdict(collections.Counter))
low = collections.defaultdict(collections.Counter)
for path, is_low in [(sys.argv[1], False)] + ([(sys.argv[2], True)] if len(sys.argv) > 2 else []):
    for l in open(path, encoding="utf-8"):
        r = json.loads(l)
        e, s, v = map(int, re.search(r"e(\d+)_s(\d+)_v(\d+)", r["video"]).groups())
        if is_low:
            low[(e, v)].update(r["counts"]["v2"])
        else:
            for k, c in r["counts"].items():
                agg[(e, v)][k].update(c)

def f(c):
    return ", ".join(f"{k} {n}" for k, n in c.most_common()) or "0"

print("| 동작 (3명 합계) | 기대 | 시점 | 규칙 v1 | 규칙 v2 | v2 + 어깨 높이 흔들기 | GRU action.pt @0.5 | GRU action_v3m.pt @0.5 |")
print("| --- | --- | --- | --- | --- | --- | --- | --- |")
for e in EV:
    for v in VIEW:
        a = agg.get((e, v))
        if not a:
            continue
        print(f"| {EV[e]} | {EXPECT[e]} | {VIEW[v]} | {f(a['v1'])} | {f(a['v2'])} | {f(low.get((e, v), collections.Counter()))} | "
              f"{f(a['action.pt@0.5'])} | {f(a['action_v3m.pt@0.5'])} |")
