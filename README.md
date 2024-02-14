# Scripting

Resume for 5 seconds

```
pgrep suspend- | xargs -n 1 kill -SIGUSR1
```



Continue for some time

```
pgrep suspend- | xargs -n 1 kill -SIGUSR2
```


```
tmux new -s suspend -d; \
tmux new-window -t suspend -n firefox './suspend-firefox.sh -d'; \
tmux new-window -t suspend -n kvm  './suspend-kvm.sh -d'; \
tmux new-window -t suspend -n chromium  './suspend-chronium.sh -d'; \
tmux attach -t suspend

tmux new -s suspend -d; \
for i in $(ls suspend-*); do \
  echo "Launching $i"; \
  tmux new-window -t suspend "while [ 1 ]; do $i -d; sleep 2; done"; \
done

```
