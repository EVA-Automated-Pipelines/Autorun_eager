#!/usr/bin/env bash

## This script accepts a list of individual IDs and clears the nextflow work directories for both SG and TF data processing of each ID.

## Helptext function
function Helptext() {
  echo -ne "\t usage: $0 [options] <ind_id_list>\n\n"
  echo -ne "This script pulls data and metadata from Autorun_eager for the TF version of the specified individual and creates a poseidon package.\n\n"
  echo -ne "Options:\n"
  echo -ne "-h, --help\t\tPrint this text and exit.\n"
}

## Print messages to stderr
function errecho() { echo -e $* 1>&2 ;}

## Parse CLI args.
TEMP=`getopt -q -o hv --long help,version -n 'update_poseidon_package.sh' -- "$@"`
eval set -- "$TEMP"

ind_id_list_fn=''

## Read in CLI arguments
while true ; do
  case "$1" in
    -h|--help) Helptext; exit 0 ;;
    --) ind_id_list_fn="${2}"; break ;;
    *) echo -e "invalid option provided: $1.\n"; Helptext; exit 1;;
  esac
done

if [[ ${ind_id_list_fn} == '' ]]; then
  echo -e "No individual ID list provided.\n"
  Helptext
  exit 1
fi

root_eager_dir='/mnt/archgen/Autorun_eager/eager_outputs' ## Directory should include subdirectories for each analysis type (TF/SG) and sub-subdirectories for each site and individual.

## Read all individual IDs into an array
input_iids=($(cat ${ind_id_list_fn}))

for ind_id in ${input_iids[@]}; do
  site_id=${ind_id:0:3} ## Site id is the first three characters of the individual ID
  errecho -ne "Clearing work directories for ${ind_id}..."
  for analysis_type in SG TF; do
    if [[ -d ${root_eager_dir}/${analysis_type}/${site_id}/${ind_id}/work ]]; then
      errecho -ne " ${analysis_type}..."
      # ls -d ${root_eager_dir}/${analysis_type}/${site_id}/${ind_id}/work
      rm -rf ${root_eager_dir}/${analysis_type}/${site_id}/${ind_id}/work
    fi
  done
  errecho ''
done