if [ $SHLVL -eq 1 ] && ! tmux has-session -t Session; then
  tmux new-session -d -s Session
  tmux split-window -h
  tmux set -g mouse on
  tmux select-pane -t 0
  tmux attach-session -t Session
fi