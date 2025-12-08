#!/usr/bin/env bash
shopt -s expand_aliases
alias yq="yq --yaml-fix-merge-anchor-to-spec=true"
exec >> logs/yml.log 2>& 1
i="$1"
i="${i%.yml}"
i="${i#./}"
if ! grep -qw "$i" .ymlignore; then
	o="$(echo "${1/src/dist}" \
		| perl -pe '
			s/yml/json/g;
			s/(\.\w+)\.json/$1/g;
		'
	)"
	yq -p yaml -o json "$1" > "$o"
fi