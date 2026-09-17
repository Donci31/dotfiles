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
