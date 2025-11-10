def dev-start [] {
    (
      podman run -it
      --name=lazyglue
      --userns=keep-id:uid=10000,gid=10000
      --env-file .devcontainer/devcontainer.env
      --add-host $"($env.SSH_REDSHIFT):127.0.0.1"
      -v $"($env.PWD):/workspaces/($env.PWD | path basename)"
      -v $"($env.USERPROFILE)/.aws:/home/hadoop/.aws"
      -v $"($env.USERPROFILE)/.gitconfig:/home/hadoop/.gitconfig"
      -v $"($env.USERPROFILE)/.config/starship.toml:/home/hadoop/.config/starship.toml"
      -v $"($env.USERPROFILE)/history.db:/home/hadoop/.local/share/atuin/history.db"
      -v $"($env.LOCALAPPDATA)/nvim:/home/hadoop/.config/nvim"
      -v $"($env.LOCALAPPDATA)/nushell:/home/hadoop/.config/nushell"
      -v $"($env.APPDATA)/nushell:/home/hadoop/.cache/nushell"
      -v "/home/user/.ssh:/home/hadoop/.ssh"
      docker.io/donci31/lazyglue pyspark
    )
}

def s [] {
  podman start lazyglue
}

def S [] {
  podman stop lazyglue
}

def e [] {
  podman exec -it -w /workspaces/($env.PWD | path basename) lazyglue nu -c "overlay use .venv/bin/activate.nu ; nu -i"
}

if ($nu.os-info.name == "windows" and $env.PODMAN) {
  s ; e
}

source ($nu.cache-dir)/carapace.nu
source ($nu.cache-dir)/zoxide.nu
source ($nu.cache-dir)/starship.nu
source ($nu.cache-dir)/uv.nu
source ~/.local/share/atuin/init.nu

