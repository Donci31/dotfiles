def clg [] {
  let devcontainer_file = if ("REPO_PATH" in $env and "REPO_NAME" in $env) {
    $"($env.REPO_PATH)/($env.REPO_NAME)/.devcontainer/devcontainer.env"
  } else {
    ".devcontainer/devcontainer.env"
  }

  let hosts = if ($devcontainer_file | path exists) {
    open $devcontainer_file
    | lines
    | parse "{key}={value}"
    | where key =~ 'SSH_.*_REDSHIFT'
    | each {|row| ["--add-host", $"($row.value | str trim -c '\"'):127.0.0.1"] }
    | flatten
  } else {
    []
  }

  let env_file_arg = if ($devcontainer_file | path exists) {
    ["--env-file", $devcontainer_file]
  } else {
    []
  }

  # Ensure self-contained container Nushell configuration exists
  let home_dir = ("~" | path expand)
  let container_nu_dir = ($home_dir | path join ".config" "lazyglue" "nushell")
  if not ($container_nu_dir | path exists) {
    mkdir $container_nu_dir
  }
  if ("/etc/nixos/devcontainer-nushell" | path exists) {
    cp -r /etc/nixos/devcontainer-nushell/* $container_nu_dir
  } else {
    let cur_aws_lib = ($nu.default-config-dir | path join "aws_lib.nu")
    if ($cur_aws_lib | path exists) {
      cp $cur_aws_lib ($container_nu_dir | path join "aws_lib.nu")
    }
    let env_file = ($container_nu_dir | path join "env.nu")
    if not ($env_file | path exists) {
      r#'$env.STARSHIP_LOG = "error"
$env.STARSHIP_CONFIG = "/home/hadoop/.config/starship.toml"

$env.config = ($env.config? | default {})
$env.config.edit_mode = "vi"
$env.config.show_banner = false
$env.config.history.file_format = "sqlite"

let starship_nu = ($nu.data-dir | path join "vendor/autoload/starship.nu")
if not ($starship_nu | path exists) {
  mkdir ($nu.data-dir | path join "vendor/autoload")
  starship init nu | save -f $starship_nu
}
'# | save -f $env_file
    }
    let cfg_file = ($container_nu_dir | path join "config.nu")
    if not ($cfg_file | path exists) {
      r#'alias v = nvim
alias l = ls
if ("/home/hadoop/.config/nushell/aws_lib.nu" | path exists) {
  source /home/hadoop/.config/nushell/aws_lib.nu
}
'# | save -f $cfg_file
    }
  }

  # Dynamically detect optional host directories/files to mount
  let ssh_candidate = [
    ($home_dir | path join ".ssh"),
    "/mnt/c/Users/szige/.ssh",
    ($env.USERPROFILE? | default "" | path join ".ssh")
  ] | where {|p| ($p != "") and ($p | path exists) } | get -o 0

  let ssh_mount = if $ssh_candidate != null {
    ["-v", $"($ssh_candidate):/home/hadoop/.ssh"]
  } else { [] }

  let aws_candidate = [
    ($home_dir | path join ".aws"),
    "/mnt/c/Users/szige/.aws",
    ($env.USERPROFILE? | default "" | path join ".aws")
  ] | where {|p| ($p != "") and ($p | path exists) } | get -o 0

  let aws_mount = if $aws_candidate != null {
    ["-v", $"($aws_candidate):/home/hadoop/.aws"]
  } else { [] }

  let pgpass_candidate = [
    ($home_dir | path join ".pgpass"),
    "/mnt/c/Users/szige/.pgpass",
    ($env.USERPROFILE? | default "" | path join ".pgpass"),
    ($env.APPDATA? | default "" | path join "postgresql" "pgpass.conf")
  ] | where {|p| ($p != "") and ($p | path exists) } | get -o 0

  let pgpass_mount = if $pgpass_candidate != null {
    ["-v", $"($pgpass_candidate):/home/hadoop/.pgpass"]
  } else { [] }

  let pgcli_candidate = [
    ($home_dir | path join ".config" "pgcli"),
    ($env.LOCALAPPDATA? | default "" | path join "dbcli" "pgcli")
  ] | where {|p| ($p != "") and ($p | path exists) } | get -o 0

  let pgcli_mount = if $pgcli_candidate != null {
    ["-v", $"($pgcli_candidate):/home/hadoop/.config/pgcli"]
  } else { [] }

  let gitconfig_candidate = [
    ($home_dir | path join ".gitconfig"),
    ($home_dir | path join ".config" "git" "config"),
    ($env.USERPROFILE? | default "" | path join ".gitconfig")
  ] | where {|p| ($p != "") and ($p | path exists) } | get -o 0

  let gitconfig_mount = if $gitconfig_candidate != null {
    ["-v", $"($gitconfig_candidate):/home/hadoop/.gitconfig"]
  } else { [] }

  let starship_candidate = [
    ($home_dir | path join ".config" "starship.toml"),
    ($env.USERPROFILE? | default "" | path join ".config" "starship.toml")
  ] | where {|p| ($p != "") and ($p | path exists) } | get -o 0

  let starship_mount = if $starship_candidate != null {
    ["-v", $"($starship_candidate):/home/hadoop/.config/starship.toml"]
  } else { [] }

  let atuin_candidate = [
    ($home_dir | path join ".local" "share" "atuin" "history.db"),
    ($env.USERPROFILE? | default "" | path join "history.db"),
    ($env.USERPROFILE? | default "" | path join ".local" "share" "atuin" "history.db")
  ] | where {|p| ($p != "") and ($p | path exists) } | get -o 0

  let atuin_mount = if $atuin_candidate != null {
    ["-v", $"($atuin_candidate):/home/hadoop/.local/share/atuin/history.db"]
  } else { [] }

  let workspace_mount = if ("REPO_PATH" in $env and "REPO_NAME" in $env) {
    ["-v", $"($env.REPO_PATH)/($env.REPO_NAME):/workspaces/($env.REPO_NAME)"]
  } else {
    ["-v", $"($env.PWD):/workspaces/($env.PWD | path basename)"]
  }

  let aws_profile_arg = if ("AWS_PROFILE" in $env and ($env.AWS_PROFILE != "")) {
    ["-e", $"AWS_PROFILE=($env.AWS_PROFILE)"]
  } else { [] }

  (
    podman run -it
    --name=lazyglue
    --userns=keep-id:uid=10000,gid=10000
    ...$env_file_arg
    ...$aws_profile_arg
    ...$hosts
    ...$workspace_mount
    ...$aws_mount
    ...$ssh_mount
    ...$pgpass_mount
    ...$pgcli_mount
    ...$gitconfig_mount
    ...$starship_mount
    ...$atuin_mount
    -v $"($container_nu_dir):/home/hadoop/.config/nushell"
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
      nu
    } else {
      nu
    }
  '#

  let repo_name = ($env.REPO_NAME? | default ($env.PWD | path basename))

  (
    podman exec -it
      -e AWS_PROFILE=($env.AWS_PROFILE? | default "")
      -w $"/workspaces/($repo_name)"
      lazyglue
      nu -c $activate_venv
  )
}

def dlg [] {
  podman rm -f lazyglue
}

if (($env.LAZYGLUE? | default "false") in ["true", true, 1, "1"]) {
  slg ; elg
}
