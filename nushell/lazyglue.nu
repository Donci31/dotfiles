def clg [] {
  let devcontainer_file = $"($env.REPO_PATH)/($env.GLUE_REPO)/.devcontainer/devcontainer.env"

  let hosts = (
    open $devcontainer_file
    | lines
    | parse "{key}={value}"
    | where key =~ 'SSH_.*_REDSHIFT'
    | each {|row| ["--add-host", $"($row.value):127.0.0.1"] }
    | flatten
  )

  (
    podman run -it
    --name=lazyglue
    --userns=keep-id:uid=10000,gid=10000
    --env-file $devcontainer_file
    ...$hosts
    -v $"($env.REPO_PATH)/($env.GLUE_REPO):/workspaces/($env.GLUE_REPO)"
    -v $"($env.REPO_PATH)/($env.SQL_REPO):/workspaces/($env.SQL_REPO)"
    -v $"($env.REPO_PATH)/($env.STEP_FN_REPO):/workspaces/($env.STEP_FN_REPO)"
    -v $"($env.USERPROFILE)/.aws:/home/hadoop/.aws"
    -v $"($env.USERPROFILE)/.gitconfig:/home/hadoop/.gitconfig"
    -v $"($env.USERPROFILE)/.config/starship.toml:/home/hadoop/.config/starship.toml"
    -v $"($env.USERPROFILE)/history.db:/home/hadoop/.local/share/atuin/history.db"
    -v $"($env.LOCALAPPDATA)/nvim:/home/hadoop/.config/nvim"
    -v $"($env.LOCALAPPDATA)/dbcli/pgcli:/home/hadoop/.config/pgcli"
    -v $"($env.LOCALAPPDATA)/nushell:/home/hadoop/.config/nushell"
    -v $"($env.APPDATA)/yazi/config:/home/hadoop/.config/yazi"
    -v $"($env.APPDATA)/nushell:/home/hadoop/.cache/nushell"
    -v "/home/user/.ssh:/home/hadoop/.ssh"
    -v "/home/user/.pgpass:/home/hadoop/.pgpass"
    docker.io/donci31/lazyglue pyspark
  )
}

def slg [] {
  podman start lazyglue
}

def Slg [] {
  podman stop lazyglue
}

def elg [] {
  let activate_venv = r#'
    if ('.venv' | path exists) {
      overlay use .venv/bin/activate.nu
      nu -i
    } else {
      nu -i
    }
  '#

  (
    podman exec -it
      -e AWS_PROFILE=($env.AWS_PROFILE)
      -w /workspaces/($env.GLUE_REPO)
      lazyglue
      nu -c $activate_venv
  )
}

def dlg [] {
  podman rm lazyglue
}

if ($nu.os-info.name == "windows" and $env.PODMAN) {
  slg ; elg
}
