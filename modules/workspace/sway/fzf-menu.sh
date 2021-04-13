IFS=':'

for p in $PATH; do
  ls "$p" 2> /dev/null
done \
  | fzf --bind "enter:execute-silent(setsid {} &)+abort"
