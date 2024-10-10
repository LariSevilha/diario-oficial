#!/usr/bin/env bash
set -o errexit
set -o pipefail

function add_admin_layout_to_controller {
  local controller_path=$1

  if [ -f "$controller_path" ]; then
    sed -i "/class Admin::/a\  layout 'admin'" "$controller_path"
  else
    echo "Controller file not found: $controller_path"
  fi
}

add_admin_layout_to_controller "$1"
