# embedding_gemma2 — AIGJ_01_011

AIP-1 「Jetson 실습 - EmbeddingGemma 2 멀티모달 임베딩」 결과. 팀 Jetson `team4`(Orin Nano Super 8GB)에서 1~10단계를 진행했다.

- 작성: 박창근 (chang0580)
- **팀원 정지원(jiwon934)의 자료·결과를 함께 썼다.** 같은 보드의 웹캠 2대를 정지원 님이 쓰고 있어 카메라 실측이 필요한 단계 일부는 정지원 님 결과를 그대로 싣고 출처를 적었다(아래 표의 "출처" 열). 정지원 님 동의를 받고 공개한다.

## 단계별 결과와 확인

| 단계 | README 결과물 | 이 저장소 | 출처 | 충족 |
|---|---|---|---|---|
| 1 환경 준비 | GPU 연산이 되는 venv | 환경은 [step6_results.md](step6_results.md) 첫 줄(torch 2.14.1+cu132, bf16) | 본인 | ✅ |
| 2 패키지·모델 | `eg2.py`의 `load()` | [eg2.py](eg2.py) (+ 미세 조정 모델용 `eg2_ft.py`, `eg2_ft2.py`) | 본인 | ✅ |
| 3 텍스트 | 질의↔문서 검색, 차원별 비교 | `test_text*.py`, `cmp_prompt.py`, `stats_step3.log` | 본인 | ✅ (768/256/128 모두 정답) |
| 4 영상 | 텍스트로 이미지·동영상 검색 | `test_vision.py`, `test_video_frames*.py`, `test_video_b2.py`, `stats_step4.log` | 본인 | ✅ (프레임 평균 방식. `{"video": ...}` 직접 입력은 torchcodec 로드 실패 — 표에 기록) |
| 5 음성 | 16kHz 모노 변환, 소리 검색 | `test_audio.py`, `stats_step5.log` | 본인 | ✅ (경보음·잡음 정답, espeak 합성 음성 질의는 오답 — 표에 기록) |
| 6 성능 측정 | 구성별 RAM·지연·GPU 표 | [step6_results.md](step6_results.md), [bench_result.md](bench_result.md) (`bench.py`) | 본인 | ✅ |
| 7 미세 조정 | `models/eg2-classroom`, 학습 전후 Recall·nDCG | [step7_result.md](step7_result.md), 코드·데이터 [step7_jiwon/](step7_jiwon/) | 데이터·스크립트 정지원, 재학습·평가 본인 | ✅ acc@1 0.833→0.850, nDCG@10 0.930→0.934 |
| 8 웹캠 물체 검색 | `app.py`, 8-4 비교표 | [app.py](app.py), [step8_result_jiwon.md](step8_result_jiwon.md) | 비교표 정지원(IP 카메라) | ⚠️ 본인 실측은 yolo 모드 실행만 함. 표 물체 중 세탁기·전지 포장·건전지, RAM 열이 비어 있음 |
| 9 동작·행동 인식 | `pose_app.py`, `pose_model.py`, `train_pose.py`, 9-4 비교 | `pose_app*.py`, `pose_model.py`, `train_pose*.py`, `pose_eval*.py`, `eval_gru.py`, `extract_feats.py` / 결과 [step9_result.md](step9_result.md), [step9_improve.md](step9_improve.md), [step9_behavior.md](step9_behavior.md), [step9_result_jiwon.md](step9_result_jiwon.md) / 회차별 [runs/](runs/) | 샘플 영상 실험 본인, 웹캠 실측·GRU 학습 데이터 정지원 | ✅ (9-3 직접 녹화는 정지원 님 데이터로 대신) |
| 10 카메라 2대 접근 감지 | `prox/` (보정 도구 2개 + `proximity_app.py`), 10-7 비교 | [prox/](prox/), 실제 교실 결과 [step10_result/](step10_result/), 공개 데이터(EPFL) 재현 [step10_result_epfl.md](step10_result_epfl.md) + [prox_epfl/](prox_epfl/), 이탈 알람 고치기 [prox_leave_fix/](prox_leave_fix/) | 교실 보정·실측 정지원, EPFL 재현·이탈 알람 수정 본인 | ✅ (10-8 이동 타겟은 정지원 님 결과 `step10_result/10-8_results.md`) |

## 공개 저장소에서 뺀 것

| 뺀 것 | 이유 | 다시 만드는 법 |
|---|---|---|
| 미세 조정 모델 가중치 `models/eg2-classroom/` (548MB), GRU `models/*.pt`, `mobileclip_blt.ts` | 용량 | 7단계: `cd step7_jiwon && python train_ft.py` (train 303쌍, 3 epoch, batch 8×accum 2, lr 2e-5, bf16, 약 4분) → `python eval_ir.py` 로 평가. 9단계 GRU: `train_pose*.py` |
| 사람이 찍힌 이미지·영상·크롭(웹캠 스냅샷, IP 카메라 캡처, 샘플 영상, EPFL 시각화 등) | 개인정보 | 샘플 영상 출처는 `step9_result.md`에 적은 Wikimedia Commons 주소 |
| 관절 좌표 CSV `data/` (약 110MB, 일부는 실제 사람 녹화) | 용량·개인정보 | `pose_app.py --record`, `extract_feats.py` |
| EPFL 데이터(영상·`calibration-6p.txt`·정답) | 배포 조건 | https://www.epfl.ch/labs/cvlab/data/data-pom-index-php/ 의 "laboratory 6p" |
| 카메라 계정(`.cam.env`, `~/.ipcam`), 실행 로그, 과제 안내 원문 사본 | 비밀정보·용량·원문 비공개 | `setcam.sh` 또는 `save_ipcam.py`가 계정을 입력받아 로컬에만 저장 |

코드 안의 `<JETSON_IP>`는 팀 Jetson 주소다.
