#!/usr/bin/env bash
shopt -s expand_aliases
alias yq="yq --yaml-fix-merge-anchor-to-spec=true"
exec >> logs/yml.log 2>& 1
i="${1#./}"
i="${i%.yml}"
if ! grep -qw "$i" .ymlignore; then
	o="${1/src/dist}"
	o="${o/yml/json}"
	o="$(echo "$o" | perl -pe 's/(\.\w+)\.json/$1/g')"
	yq -p yaml -o json "$1" > "$o"
fi