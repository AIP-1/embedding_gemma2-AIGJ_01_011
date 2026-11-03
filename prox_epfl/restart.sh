cd ~/eg2-lab/prox_epfl
tmux kill-session -t eg2prox
for p in $(pgrep -u prettygeun -f "^python prox_epfl.py"); do kill $p; done
cp -n prox_epfl.py prox_epfl.py.bak_gt
source ~/eg2/bin/activate && python fix_gt.py || exit 1
mv run.log run_gtbug.log; mv results.jsonl results_gtbug.jsonl
tmux new -d -s eg2prox "bash ~/eg2-lab/prox_epfl/run.sh 2>&1 | tee ~/eg2-lab/prox_epfl/run.log"
sleep 2; tmux ls; pgrep -u prettygeun -fa "^python prox_epfl"
