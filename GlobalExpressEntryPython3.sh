#!/bin/bash

# Runs the Melissa Global Express Entry Cloud API Python 3 sample.
#
# This script runs GlobalExpressEntryPython3.py with python3, passing along the license
# and (if supplied) the address fields.
#
# Overall flow:
#   1. Parse the command-line options below.
#   2. Resolve the license (--license, then a prompt, then the MD_LICENSE environment variable).
#   3. Run GlobalExpressEntryPython3.py: with the address fields if any was supplied,
#      otherwise with only the license (the Python program prompts for each field).
#
# Options (each takes a value):
#   --addressline1   Street address (or partial address) to look up.
#   --city           City to look up.
#   --state          State to look up.
#   --postal         Postal code to look up.
#   --license        License string. If omitted, the script prompts for it; if the prompt
#                    is left blank, it falls back to MD_LICENSE. Running without --license
#                    always prompts, even when MD_LICENSE is set.
#
# Examples:
#   ./GlobalExpressEntryPython3.sh --license "your-license"
#   ./GlobalExpressEntryPython3.sh --addressline1 "22382 Avenida Empresa" --city "Rancho Santa Margarita" --state "CA" --postal "92688" --license "your-license"

######################### Constants ##########################

RED='\033[0;31m' #RED
NC='\033[0m' # No Color

######################### Parameters ##########################

addressline1=""
city=""
state=""
postal=""
license=""

# Read each --flag and its value. A flag with no value, or whose value starts with "-",
# is an error. Unrecognized options are ignored.
while [ $# -gt 0 ] ; do
  case $1 in
    --addressline1) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'addressline1\'.${NC}\n"  
            exit 1
        fi 

        addressline1="$2"
        shift
        ;;
    --city)  
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'city\'.${NC}\n"  
            exit 1
        fi 

        city="$2"
        shift
        ;;
    --state) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'state\'.${NC}\n"  
            exit 1
        fi 

        state="$2"
        shift
        ;;
    --postal)         
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'postal\'.${NC}\n"  
            exit 1
        fi 
        
        postal="$2"
        shift
        ;;
    --license) 
        if [ -z "$2" ] || [[ $2 == -* ]];
        then
            printf "${RED}Error: Missing an argument for parameter \'license\'.${NC}\n"  
            exit 1
        fi 

        license="$2"
        shift 
        ;;
  esac
  shift
done

########################## Main ############################
printf "\n==================== Melissa Global Express Entry Cloud API =====================\n"

# Get license (either from parameters or user input)
if [ -z "$license" ];
then
  printf "Please enter your license string: "
  read license
fi

# Check for License from Environment Variables 
if [ -z "$license" ];
then
  license=`echo $MD_LICENSE` 
fi

if [ -z "$license" ];
then
  printf "\nLicense String is invalid!\n"
  exit 1
fi

# Run project
# No address fields supplied -> run with only the license (the program prompts for each field);
# otherwise pass them all through. Unsupplied fields arrive as empty strings, and the
# program prompts for them.
if [ -z "$addressline1" ] && [ -z "$city" ] && [ -z "$state" ] && [ -z "$postal" ];
then
    python3 GlobalExpressEntryPython3.py --license "$license"
else
    python3 GlobalExpressEntryPython3.py \
      --license "$license" \
      --addressline1 "$addressline1" \
      --city "$city" \
      --state "$state" \
      --postal "$postal"
fi