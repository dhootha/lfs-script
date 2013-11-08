#!/bin/bash
################################################################################
# Функция "color-echo"
# Version: 0.1

local red='\033[0;31m'
local RED='\033[1;31m'
local green='\033[0;32m'
local GREEN='\033[1;32m'
local yellow='\033[0;33m'
local YELLOW='\033[1;33m'
local blue='\033[0;34m'
local BLUE='\033[1;34m'
local magenta='\033[0;35m'
local MAGENTA='\033[1;35m'
local cyan='\033[0;36m'
local CYAN='\033[1;36m'
local white='\033[0;37m'
local WHITE='\033[1;37m'
local NC='\033[0m' # No Color

color-echo ()
{
local default_msg='Нет сообщения.'

local message="${1:-$default_msg}"
local color=${2:-$NC}

[ -n "${LOG_DIR}" ] && echo ${message} >> "${LOG_DIR}/build.log"

echo -e "${color}${message}${NC}"
}

color-echo-debug ()
{
local default_msg='Нет сообщения.'

local message=${1:-$default_msg}

echo -e "${YELLOW}============================${2}===========================${NC}"
echo -e "${YELLOW}"${message}"${NC}"
echo -e "${YELLOW}===========================================================${NC}"
read
}

################################################################################
