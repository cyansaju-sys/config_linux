# Run fastfetch only in the first Kitty terminal; resets when that terminal closes
if [[ -n "$KITTY_WINDOW_ID" ]]; then
  _fastfetch_lock="/tmp/.fastfetch_shown_kitty"
  if [[ -f "$_fastfetch_lock" ]]; then
    _fastfetch_pid=$(<"$_fastfetch_lock")
    kill -0 "$_fastfetch_pid" 2>/dev/null || rm -f "$_fastfetch_lock"
    unset _fastfetch_pid
  fi
  if [[ ! -f "$_fastfetch_lock" ]]; then
    echo "$$" > "$_fastfetch_lock"
    fastfetch
  fi
  unset _fastfetch_lock
fi
