def --env y [...args] {
 let tmp = (mktemp -t "yazi-cwd.XXXXXX")
 yazi ...$args --cwd-file $tmp
 let cwd = (open $tmp)
 if $cwd != "" and $cwd != $env.PWD {
  cd $cwd
 }
 rm -fp $tmp
}

source ($nu.cache-dir)/carapace.nu
source ($nu.cache-dir)/zoxide.nu
source ($nu.cache-dir)/starship.nu
source ($nu.cache-dir)/uv.nu
source ~/.local/share/atuin/init.nu

