$env.EDITOR = "nvim"
$env.STARSHIP_LOG = "error"

$env.config.edit_mode = "vi"
$env.config.show_banner = false

alias v = nvim

mkdir $nu.cache-dir
carapace _carapace nushell | save -f $"($nu.cache-dir)/carapace.nu"
zoxide init nushell | save -f $"($nu.cache-dir)/zoxide.nu"
starship completions nushell | save -f $"($nu.cache-dir)/starship.nu"
uv generate-shell-completion nushell | save -f $"($nu.cache-dir)/uv.nu"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

