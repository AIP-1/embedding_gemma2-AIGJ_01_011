cd ~/eg2-lab/prox_epfl
tmux kill-session -t eg2prox
for p in $(pgrep -u prettygeun -f "^python prox_epfl.py"); do kill $p; done
cp -n prox_epfl.py prox_epfl.py.bak_timing 2>/dev/null
source ~/eg2/bin/activate && python fix_alarm.py && python -c "import ast;ast.parse(open('prox_epfl.py').read())" || exit 1
mv run.log run_gpu_stereo_only.log; cp results.jsonl results_before_timing.jsonl
tmux new -d -s eg2prox "bash ~/eg2-lab/prox_epfl/run_gpu.sh 2>&1 | tee ~/eg2-lab/prox_epfl/run.log"
sleep 1; tmux ls
