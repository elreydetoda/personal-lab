#!/usr/bin/env bash

# https://elrey.casa/bash/scripting/harden
set -${-//[sc]/}eu${DEBUG:+xv}o pipefail

# getting this error when running on NixOS
export LC_ALL="C.UTF-8"
source .devenv/state/venv/bin/activate