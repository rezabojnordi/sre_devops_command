```
ps aux |grep nginx

pid=869

cat /proc/869/oom


vmstat -s


ps aux --sort=-%mem | head -n 10


linux at first check pid and if scor is big at first remove the big score


cat /proc/800/oom_score_adj
-10000


cat /proc/869/oom_score_adj
0

```
