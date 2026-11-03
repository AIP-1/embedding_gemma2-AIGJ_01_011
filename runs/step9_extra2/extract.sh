cd ~/eg2-lab && source ~/eg2/bin/activate
M=media/pose/mixkit; P=media/pose
X(){ python extract_feats.py "$@" 2>&1 | grep -v -e half -e WARN; }
# 학습용 (data/action_v2: 정지원님 웹캠 데이터 + 아래 영상)
X --label arms_crossed --out data/action_v2/arms_crossed.csv $M/mk28302_arms_crossed_man_green.mp4 $M/mk11653_arms_crossed_woman_standing.mp4
X --label clap --out data/action_v2/clap.csv $P/clapping_nhs.webm
X --label wave --out data/action_v2/wave.csv $M/mk33479_waving_two_boys.mp4
# 테스트용 (학습에 안 쓴 영상)
X --label arms_crossed --out data/action_test/arms_crossed.csv $M/mk29963_arms_crossed_woman_livingroom.mp4
X --label clap --out data/action_test/clap.csv $P/applause_wikiconvention.webm
X --label wave --out data/action_test/wave.csv $P/wave_example.webm
X --label idle --out data/action_test/idle.csv media/samples/vtest.avi
echo EXDONE
