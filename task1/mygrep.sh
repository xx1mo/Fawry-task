#!/bin/bash

# My custom grep tool - made with love and caffeine to >>>FAWRY<<<<
# Author: Mohamed Mosad

#######################################
# Let's set up some pretty colors first
# because black and white is so 1980s
#######################################
RED='\033[0;31m'     # For when things go wrong
GREEN='\033[0;32m'   # For happy success messages
YELLOW='\033[0;33m'  # For warnings
NC='\033[0m'         # No Color (reset)

# Current version - because we're professional
VERSION="1.1"

#######################################
# Show help message - everyone needs help sometimes
#######################################
show_help() {
  echo -e "\n${GREEN}Welcome to mygrep!${NC}"
  echo "A simpler grep alternative that gets the job done"
  echo ""
  echo -e "${YELLOW}Basic Usage:${NC}"
  echo "  $0 [options] search_term [file]"
  echo ""
  echo -e "${YELLOW}Common Options:${NC}"
  echo "  -n, --numbers      Show line numbers (helps when you're lost)"
  echo "  -v, --invert       Show lines that DON'T match (contrarian mode)"
  echo "  -i, --ignore-case  Case insensitive (because capitals don't matter)"
  echo "  --color            Make matches pretty (for your eyeballs)"
  echo "  --help             Show this message (you're looking at it)"
  echo ""
  echo -e "${GREEN}Examples:${NC}"
  echo "  $0 error log.txt              # Find all errors"
  echo "  $0 -n warning log.txt        # Find warnings with line numbers"
  echo "  $0 -v boring file.txt        # Find anything NOT boring"
  echo ""
}

#######################################
# Let's handle those command line options
# because users can't be trusted to read docs
#######################################
show_numbers=false
invert_match=false
use_color=false
ignore_case=true  # Default because who likes case sensitivity?

# Parse options like a pro
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--numbers)
      show_numbers=true
      shift
      ;;
    -v|--invert)
      invert_match=true
      shift
      ;;
    -i|--ignore-case)
      ignore_case=true  # Already true, but let's be explicit
      shift
      ;;
    --color)
      use_color=true
      shift
      ;;
    --help)
      show_help
      exit 0
      ;;
    --version)
      echo -e "${GREEN}mygrep version ${VERSION}${NC}"
      exit 0
      ;;
    -*)
      echo -e "${RED}Oops! Unknown option: $1${NC}" >&2
      show_help
      exit 1
      ;;
    *)
      # First non-option is our search term
      if [[ -z "$search_term" ]]; then
        search_term="$1"
      else
        # Second non-option is our file
        if [[ -z "$input_file" ]]; then
          input_file="$1"
        else
          echo -e "${RED}Whoa there! Too many arguments.${NC}" >&2
          show_help
          exit 1
        fi
      fi
      shift
      ;;
  esac
done

#######################################
# Validate our inputs
# because garbage in = garbage out
#######################################
if [[ -z "$search_term" ]]; then
  echo -e "${RED}Hey! You forgot to tell me what to search for!${NC}" >&2
  show_help
  exit 1
fi

if [[ -z "$input_file" ]]; then
  # Check if we're getting input from a pipe or redirect
  if [[ -t 0 ]]; then
    echo -e "${RED}Wait... where's the file? I need something to search!${NC}" >&2
    show_help
    exit 1
  else
    echo -e "${YELLOW}Pro tip: Reading from stdin (piped input)${NC}" >&2
  fi
else
  if [[ ! -f "$input_file" ]]; then
    echo -e "${RED}Seriously? File '$input_file' doesn't exist.${NC}" >&2
    exit 1
  fi
  if [[ ! -r "$input_file" ]]; then
    echo -e "${RED}Uh oh... can't read '$input_file'. Permission issues?${NC}" >&2
    exit 1
  fi
fi

#######################################
# Build our grep command
# like assembling a sandwich
#######################################
grep_command="grep"

# Add the right ingredients
$ignore_case && grep_command+=" -i"
$show_numbers && grep_command+=" -n"
$invert_match && grep_command+=" -v"
$use_color && grep_command+=" --color=auto"

# Add the main ingredients
grep_command+=" \"$search_term\""

# Add the file if we have one
[[ -n "$input_file" ]] && grep_command+=" \"$input_file\""

#######################################
# Let's cook! (Run the command)
#######################################
echo -e "${GREEN}Searching for:${NC} $search_term"
if [[ -n "$input_file" ]]; then
  echo -e "${GREEN}In file:${NC} $input_file"
fi

# Show our fancy command if we're using color
$use_color && echo -e "${YELLOW}Running:${NC} $grep_command"

# Actually run it
eval "$grep_command"

# Check if it worked
result=$?
if [[ $result -eq 0 ]]; then
  echo -e "${GREEN}Search complete!${NC}"
elif [[ $result -eq 1 ]]; then
  echo -e "${YELLOW}No matches found. Maybe try different terms?${NC}"
else
  echo -e "${RED}Oops! Something went wrong with grep (code $result)${NC}" >&2
  exit $result
fi
