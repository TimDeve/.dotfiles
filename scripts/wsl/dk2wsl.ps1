#!/usr/bin/env powershell.exe
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

function checkExit {
    if (-not $?) { throw "Last command failed" }
}

function usage {
  echo "Usage: dk2wsl.ps1 DOCKER_IMAGE_NAME [DISTRO_NAME] [INSTALL_PATH]"
  echo ""
  echo "Arguments:"
  echo "  DOCKER_IMAGE_NAME   REQUIRED"
  echo "  DISTRO_NAME         OPTIONAL"
  echo "  INSTALL_PATH        OPTIONAL"
}

function cleanup {
  try {
    rm $temp_file
  } catch {}

  try {
    docker rm $container_name 2>$null | Out-Null
  } catch {}
}
trap { echo "Error happened, cleaning up..."; cleanup }

if ($args.count -eq 0) {
  usage
  echo ""
  echo "DOCKER_IMAGE_NAME is required"
  exit
}

$image_name=$args[0]
if (($image_name -eq "-h") -or ($image_name -eq "--help")) {
  usage
  exit
}

$container_name="dk2wsl-$(New-Guid)"

if ($args.count -gt 1) {
  $distro_name=$args[1]
} else {
  $distro_name="$image_name"
}

if ($args.count -gt 2) {
  $install_dir=$args[2]
} else {
  $install_dir="$HOME\wsl\$distro_name"
}

echo "Distro '$distro_name' based on '$image_name' image will be installed at '$install_dir'"

$temp_file=$(New-TemporaryFile)

docker run -it --name $container_name --entrypoint /bin/sh $image_name -c 'exit 0'; checkExit
docker export --output ($temp_file).fullname $container_name; checkExit
md -Force $install_dir | Out-Null
wsl --import $distro_name $install_dir ($temp_file).fullname; checkExit

echo "Created '$distro_name'"
echo "Cleaning up..."
cleanup
echo "Done, run 'wsl.exe -d $distro_name' to access new WSL"

