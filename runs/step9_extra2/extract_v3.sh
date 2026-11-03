cd ~/eg2-lab && source ~/eg2/bin/activate
X(){ python extract_feats.py "$@" 2>&1 | grep -v -e half -e WARN; }
X --label clap --out data/action_v3/clap.csv media/pose/mixkit/mk23085_clap_office.mp4 media/pose/mixkit/mk48667_clap_group_therapy.mp4 media/pose/mixkit/mk5953_clap_seminar.mp4 media/pose/mixkit/mk24214_clap_conference.mp4
X --label idle --out data/action_v3/idle.csv media/pose/mixkit/mk4519_idle_students_walking.mp4 media/pose/mixkit/mk25890_idle_people_walking.mp4 media/pose/mixkit/mk98_idle_person_crosswalk.mp4 media/pose/mixkit/mk460_idle_standing_woman.mp4 media/pose/mixkit/mk46711_idle_standing_man_rain.mp4
echo EXDONE
