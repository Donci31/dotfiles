$env.EDITOR = "nvim"
$env.STARSHIP_LOG = "error"
$env.PGCLIENTENCODING = "utf-8"

$env.config = ($env.config? | default {})
$env.config.edit_mode = "vi"
$env.config.show_banner = false
$env.config.history.file_format = "sqlite"

# Auto-generate uv completions into vendor/autoload if uv is available
let uv_autoload = ($nu.data-dir | path join "vendor/autoload/uv.nu")
if not ($uv_autoload | path exists) {
  mkdir ($nu.data-dir | path join "vendor/autoload")
  try { uv generate-shell-completion nushell | save -f $uv_autoload }
}

# Optional user extensions (extra.nu: optional local extension file)
let extra_src = ($nu.default-config-dir | path join "extra.nu")
let extra_cache = ($nu.cache-dir | path join "extra.nu")
if not ($nu.cache-dir | path exists) { mkdir $nu.cache-dir }
if ($extra_src | path exists) {
  cp -f $extra_src $extra_cache
} else {
  touch $extra_cache
}
