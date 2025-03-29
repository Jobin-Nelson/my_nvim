local ls = require('luasnip')
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local autosnippets = {}

-- Snippets go here

local snippets = {
  s({ trig = 'parse' },
    t(vim.split([=[
while :; do
  case "${1-}" in
  -h | --help) usage ;;
  -v | --verbose) set -x ;;
  --no-color) NO_COLOR=1 ;;
  -f | --flag) flag=1 ;; # example flag
  -p | --param) # example named parameter
    param="${2-}"
    shift
    ;;
  -?*) die "Unknown option: $1" ;;
  *) break ;;
  esac
  shift
done

[[ $# == 0 ]] && help
]=], '\n'))
  ),

  s({ trig = 'helpdoc' },
    fmt([=[
function help() {{
  cat <<EOM
SYNOPSIS
    $0 [-h] {}

DESCRIPTION
    {}

OPTIONS
    -{}   {}
    -h    Print this help

EXAMPLES
    $0 {}

EOM
}}
]=], {
      i(1), i(2, 'brief description of the script'), rep(1), i(3), i(0)
    })
  ),

  s({ trig = 'script-template' },
    t(vim.split([=[
#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Global Variables                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# shellcheck disable=SC2034
SCRIPT_DIR="${0%/*}"


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Utility Functions                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


usage() {
  local script="${0%%*/}"

  cat <<EOF
SYNOPSIS
    ${script} [-h] [-v] [-f] -p param_value arg1 [arg2...]

DESCRIPTION
    Script description here.

OPTIONS
    -h, --help      Print this help and exit
    -v, --verbose   Print script debug info
    -f, --flag      Some flag description
    -p, --param     Some param description

EXAMPLES
    ${script} {}

EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    # shellcheck disable=SC2034
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo -e "${GREEN}${1-}${NOFORMAT}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  echo "${RED}${msg}${NOFORMAT}" >&2
  exit "$code"
}


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                   Core Implementation                    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛




# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                     Parse Arguments                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


parse_params() {
  # default values of variables set from params
  flag=0
  param=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -f | --flag) flag=1 ;; # example flag
    -p | --param) # example named parameter
      param="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ -z "${param-}" ]] && die "Missing required parameter: param"
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

[[ $# == 0 ]] && usage
parse_params "$@"
setup_colors

# script logic here

msg "${RED}Read parameters:${NOFORMAT}"
msg "- flag: ${flag}"
msg "- param: ${param}"
msg "- arguments: ${args[*]-}"

]=], '\n'))
  ),

  s({ trig = 'funcdoc' },
    fmt([[
#######################################
# {}
#   {}
# Globals:
#   {}
# Arguments:
#   {}
# Outputs:
#   {}
# Returns:
#   {}
######################################
]], {
      i(1, 'Function name'),
      i(2, 'Description of function'),
      i(3, 'List all globals used'),
      i(4, 'None'),
      i(5, 'Output to stdout or stderr'),
      i(6, 'Description of returned value')
    })
  ),
}

-- End snippets

return snippets, autosnippets
