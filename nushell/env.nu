$env.EDITOR = "nvim"
$env.STARSHIP_LOG = "error"

$env.config.edit_mode = "vi"
$env.config.show_banner = false

alias v = nvim

mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save -f $"($nu.cache-dir)/carapace.nu"
zoxide init nushell | save -f $"($nu.cache-dir)/zoxide.nu"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

