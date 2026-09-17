# Aliases
alias v = nvim
alias l = ls
alias ffmpeg = ^ffmpeg -hide_banner
alias ffprobe = ^ffprobe -hide_banner
alias ffplay = ^ffplay -hide_banner

# Helper scripts
source ($nu.default-config-dir)/lazyglue.nu
source ($nu.default-config-dir)/aws_lib.nu

# Optional user extensions
source ($nu.cache-dir)/extra.nu
