
# ---------------------------------------------------------
# -- 1.2) Set up bash prompt and ~/.bash_eternal_history --
# ---------------------------------------------------------
# Set various bash parameters based on whether the shell is 'interactive'
# or not. An interactive shell is one you type commands into, a
# non-interactive one is the bash environment used in scripts.
if [ "$PS1" ]; then
if [ -x /usr/bin/tput ]; then
if [ "x`tput kbs`" != "x" ]; then # We can't do this with "dumb" terminal
stty erase `tput kbs`
elif [ -x /usr/bin/wc ]; then
if [ "`tput kbs|wc -c `" -gt 0 ]; then # We can't do this with "dumb" terminal
stty erase `tput kbs`
fi
fi
fi
case $TERM in
xterm*)
if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
else
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
fi
;;
screen)
if [ -e /etc/sysconfig/bash-prompt-screen ]; then
PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
else
PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
fi
;;
*)
[ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
;;
esac
# Bash eternal history
# --------------------
# This snippet allows infinite recording of every command you've ever
# entered on the machine, without using a large HISTFILESIZE variable,
# and keeps track if you have multiple screens and ssh sessions into the
# same machine. It is adapted from:
# http://www.debian-administration.org/articles/543.
#
# The way it works is that after each command is executed and
# before a prompt is displayed, a line with the last command (and
# some metadata) is appended to ~/.bash_eternal_history.
#
# This file is a tab-delimited, timestamped file, with the following
# columns:
#
# 1) user
# 2) hostname
# 3) screen window (in case you are using GNU screen)
# 4) date/time
# 5) current working directory (to see where a command was executed)
# 6) the last command you executed
#
# The only minor bug: if you include a literal newline or tab (e.g. with
# awk -F"\t"), then that will be included verbatime. It is possible to
# define a bash function which escapes the string before writing it; if you
# have a fix for that which doesn't slow the command down, please submit
# a patch or pull request.
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo -e $$\\t$USER\\t$HOSTNAME\\tscreen $WINDOW\\t`date +%D%t%T%t%Y%t%s`\\t$PWD"$(history 1)" >> ~/.bash_eternal_history'
# Turn on checkwinsize
shopt -s checkwinsize
#Prompt edited from default
[ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u \w]\\$ "
if [ "x$SHLVL" != "x1" ]; then # We're not a login shell
for i in /etc/profile.d/*.sh; do
if [ -r "$i" ]; then
. $i
fi
done
fi
fi
# Append to history
# See: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
shopt -s histappend
# Make prompt informative
# See: http://www.ukuug.org/events/linux2003/papers/bash_tips/
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
## -----------------------
## -- 2) Set up aliases --
## -----------------------
# 2.1) Safety
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
set -o noclobber
# 2.2) Listing, directories, and motion
alias ll="ls -alrtF --color"
alias la="ls -A"
alias l="ls -CF"
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias m='less'
alias ..='cd ..'
alias ...='cd ..;cd ..'
alias md='mkdir'
alias cl='clear'
alias du='du -ch --max-depth=1'
alias treeacl='tree -A -C -L 2'
# Note: ~/.ssh/environment should not be used, as it
# already has a different purpose in SSH.
env=~/.ssh/agent.env
# Note: Don't bother checking SSH_AGENT_PID. It's not used
# by SSH itself, and it might even be incorrect
# (for example, when using agent-forwarding over SSH).
agent_is_running() {
if [ "$SSH_AUTH_SOCK" ]; then
# ssh-add returns:
# 0 = agent running, has keys
# 1 = agent running, no keys
# 2 = agent not running
ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]
else
false
fi
}
agent_has_keys() {
ssh-add -l >/dev/null 2>&1
}
agent_load_env() {
. "$env" >/dev/null
}
agent_start() {
(umask 077; ssh-agent >"$env")
. "$env" >/dev/null
}
if ! agent_is_running; then
agent_load_env
fi
# if your keys are not stored in ~/.ssh/id_rsa.pub or ~/.ssh/id_dsa.pub, you'll need
# to paste the proper path after ssh-add
if ! agent_is_running; then
agent_start
ssh-add
elif ! agent_has_keys; then
ssh-add
fi
unset env
