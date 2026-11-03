# 9단계 결과: 샘플 영상 동작 판정 비교 (2026-10-26)

입력: 웹캠 대신 인터넷 샘플 영상(출처는 media/pose/SOURCES.txt). yolo11n-pose.pt, conf 0.5. 횟수 = '기본'이 아닌 동작으로 바뀐 횟수(pose_app.py의 동작 기록과 같은 기준).

## applause_wikiconvention.webm (3.7초, 처리 8.8 fps, 추적 ID 9개)

| 동작 | raw (9-1) | smooth (9-2) | GRU action.pt (9-6) |
| --- | --- | --- | --- |
| 만세 | 16 | 2 | 0 |
| 손흔들기 | 0 | 1 | 0 |
| 악수 | 9 | 4 | 0 |
| 한팔들기 | 20 | 1 | 0 |
| 합계 | 45 | 8 | 0 |

