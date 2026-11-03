cd ~/eg2-lab && source ~/eg2/bin/activate
M=media/pose/mixkit
X(){ python extract_feats.py "$@" 2>&1 | grep -v -e half -e WARN | grep "→"; }
mkdir -p data/action_r2
for l in arms_crossed clap idle wave; do cp -p data/action_v6/$l.csv data/action_r2/; done
X --label arms_crossed --out data/action_r2/arms_crossed.csv $M/mk45997_arms_man_folding.mp4 $M/mk45422_arms_witch.mp4 $M/mk50924_arms_couple_climbing.mp4
X --label clap --out data/action_r2/clap.csv $M/mk43835_clap_man_green.mp4 $M/mk43822_clap_proud_man.mp4 $M/mk43820_clap_man_lens.mp4 $M/mk13276_clap_tattoo_man.mp4 $M/mk11836_clap_man_suit.mp4 $M/mk5390_clap_balcony.mp4 $M/mk36153_clap_standing_meeting.mp4 $M/mk43813_clap_proud_woman.mp4
X --label wave --out data/action_r2/wave.csv $M/mk24941_wave_model_goodbye.mp4 $M/mk24975_wave_bus_driver.mp4 $M/mk48999_wave_santas.mp4 $M/mk100320_wave_friends_indoors.mp4 $M/mk43810_wave_woman_front.mp4 $M/mk33482_wave_friends_grass.mp4
X --label idle --out data/action_r2/idle.csv $M/mk28329_idle_students_wall.mp4 $M/mk50389_idle_posing_poster.mp4 $M/mk1457_idle_workers.mp4
wc -l data/action_r2/*.csv
for opt in "--mirror" "--mirror --lowdrop" "--mirror --balance"; do
  n=action_r2$(echo $opt | sed "s/--mirror/m/; s/ --lowdrop/_ld/; s/ --balance/_b/")
  python train_pose_v4.py --data data/action_r2 --task action --window 30 $opt --out models/$n.pt > runs/step9_loop/train_$n.log 2>&1
  echo "trained $n"
done
echo "=== 스톡"; python eval_gru.py --data data/action_test_v6 models/action_r2m.pt models/action_r2m_ld.pt models/action_r2m_b.pt 2>/dev/null | grep -E "^###|^\| (전체|arms|clap|idle|wave)"
for v in 1 2 3 7; do echo "=== WVU V$v"; python eval_gru.py --data data/action_test_wvu/v$v models/action_r2m.pt models/action_r2m_ld.pt models/action_r2m_b.pt 2>/dev/null | grep -E "^###|^\| 전체"; done
echo ALLDONE
