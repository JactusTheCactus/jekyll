#!/usr/bin/env bash
set -euo pipefail
shopt -s expand_aliases
alias yq="yq --yaml-fix-merge-anchor-to-spec=true"
exec > "logs/pre.log" 2>& 1
data="$(yq -p yaml -o json "data/data.yml" | jq "del(.[0])")"
echo "$(
	yq data/data.yml \
		-p yaml \
		-o json \
		| jq "del(.[0])"
	)" \
		| jq -c ".[]" \
		| while read -r m
do
	m="$(echo "$m" | jq --tab ".")"
	t="dist/datapacks/Project: Jekyll/data/jekyll/function/mob/$(
		t_="$(echo "$m" | jq -r ".name")"
		echo "${t_,,}"
	)/give.mcfunction"
	echo "give @p minecraft:dragon_breath[custom_name=\"$(
		g_="$(echo "$m" | jq -r ".blood")"
		if [[ -z "$g_" ]]; then
			echo "$m" | jq -r ".name"
		else
			echo "$g_"
		fi
	) Blood\",$(
		g_="$(echo "$m" | jq -c ".desc")"
		if [[ "$g_" != "[]" ]]; then
			echo "lore=$g_,"
		fi
	)custom_model_data={$(
		g_="$(echo "$m" | jq -r ".name")"
		echo "strings:[${g_,,}]"
	)},consumable={consume_seconds:0}]" > "dist/datapacks/Project: Jekyll/data/jekyll/function/mob/$(
		t_="$(echo "$m" | jq -r ".name")"
		echo "${t_,,}"
	)/give.mcfunction"
done