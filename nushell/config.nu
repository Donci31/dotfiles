# Yazi wrapper to change directory on exit
def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}

# Aliases
alias v = nvim
alias l = ls
alias ffmpeg = ^ffmpeg -hide_banner
alias ffprobe = ^ffprobe -hide_banner
alias ffplay = ^ffplay -hide_banner

# Helper scripts
source ($nu.default-config-dir)/lazyglue.nu
source ($nu.default-config-dir)/aws_lib.nu

# Completions & integrations
source ($nu.cache-dir)/carapace.nu
source ($nu.cache-dir)/zoxide.nu
source ($nu.cache-dir)/starship.nu
source ($nu.cache-dir)/uv.nu
source ($nu.cache-dir)/extra.nu
source ~/.local/share/atuin/init.nu
