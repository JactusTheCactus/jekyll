#!/usr/bin/env bash
set -euo pipefail
shopt -s expand_aliases
yml() {
	yq --yaml-fix-merge-anchor-to-spec=true "$@"
}
exec > "logs/pre/init.log" 2>& 1
get() {
	echo "$1" | jq -r ".${2:-}"
}
void() {
	if [[ "$1" = "null" ]]
		then echo "${2:-N/A}"
		else echo "$1"
	fi
}
while read -r m
	do while read -r f
		do echo "$(echo "$f" | jq -r ".function")" \
			> "dist/datapacks/Project: Jekyll/data/jekyll/function/mob/$(
				echo "$m" | jq -r ".name"
			)/$(
				echo "$f" | jq -r ".id"
			).mcfunction"
	done < <(echo "$m" | jq -c ".functions[]?")
done < <(yml data/data.yml -p yaml -o json | jq -c ".[]")