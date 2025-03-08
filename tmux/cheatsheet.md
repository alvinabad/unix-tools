# Start Session
```
tmux                     #
tmux new -s sess1        # start new session with name sess1
```

# List sessions
```
tmux ls
```

# kill session
tmux kill-session
tmux kill-session -t sess1
tmux kill-session -t sess2
ctrl-b x

# Attach/detach session
```
ctrl-b d                 # detach session
tmux a                   # attach to recent session
tmux a -t 0
tmux a -t sess1
```

# Create new pane
```
ctrl-b %            # spliy pane vertically
ctrl-b  "           # split pane horizontally
ctrl-b arrow        # switch panes
crtl-b alt-arrow   # resize pane
ctrl-b o            # switch pane
crtl-b q0
crtl-b q1
crtl-b q2
ctrl-b alt arrow    #
```

# create new window
```
ctrl-b c
ctlr-b n
ctrl-b w0
ctrl-b w1
ctrl-b w2
```

