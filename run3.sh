cd ~/eg2-lab; . ~/eg2/bin/activate
tegrastats --interval 1000 --logfile tegra3.log & TP=$!
for f in test_text test_text test_text_noprompt test_text_noprompt; do
  echo "=== $f $(date +%T)"; TIMEFORMAT="wall %Rs"; time { python $f.py 2>&1 | grep -vE "it/s|unauthenticated"; }
done
kill $TP; echo DONE
