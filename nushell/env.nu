$env.LAZYGLUE = false
$env.EDITOR = "nvim"
$env.STARSHIP_LOG = "error"
$env.PGCLIENTENCODING = "utf-8"

$env.config = ($env.config? | default {})
$env.config.edit_mode = "vi"
$env.config.show_banner = false
$env.config.history.file_format = "sqlite"

mkdir $nu.cache-dir
try { carapace _carapace nushell | save -f ($nu.cache-dir)/carapace.nu } catch { touch ($nu.cache-dir)/carapace.nu }
try { zoxide init nushell | save -f ($nu.cache-dir)/zoxide.nu } catch { touch ($nu.cache-dir)/zoxide.nu }
try { starship completions nushell | save -f ($nu.cache-dir)/starship.nu } catch { touch ($nu.cache-dir)/starship.nu }
try { uv generate-shell-completion nushell | save -f ($nu.cache-dir)/uv.nu } catch { touch ($nu.cache-dir)/uv.nu }

# Optional user extensions (extra.nu: optional local extension file)
let extra_src = ($nu.default-config-dir | path join "extra.nu")
let extra_cache = ($nu.cache-dir | path join "extra.nu")
if ($extra_src | path exists) {
  cp -f $extra_src $extra_cache
} else {
  touch $extra_cache
}

mkdir ($nu.data-dir | path join "vendor/autoload")
try { starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu") }

let atuin_dir = ("~/.local/share/atuin" | path expand)
mkdir $atuin_dir
if $nu.os-info.name == "linux" and (($env.LAZYGLUE? | default "false") in ["true", true, 1, "1"]) {
  try { atuin init nu | save -f ($atuin_dir | path join "init.nu") } catch { touch ($atuin_dir | path join "init.nu") }
} else {
  touch ($atuin_dir | path join "init.nu")
}
