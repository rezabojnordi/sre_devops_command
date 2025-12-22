## check the block increasing per time
```
journalctl -fu injectived | grep height | grep Comm | pv -i 10 -l -r > /dev/null

journalctl -fu injectived | grep -i height | grep -i comm | pv -i 10 -l -r > /dev/null


journalctl -fu injectived | grep height | grep Comm | pv -i 10 -l -r

```
