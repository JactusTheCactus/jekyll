#!/usr/bin/env bash
set -euo pipefail
yml() {
	yq \
		--yaml-fix-merge-anchor-to-spec=true \
		"$@"
}
exec > README.md
exec 2> logs/readme.log
el() {
	e=${1:-hr}
	t=${@:2}
	tag="<$e>$t</$e>"
	first=${e%%:*}
	rest=${e#*:}
	if ! [[ $first = $e && $rest = $e ]]
		then o=$(el $first $(el $rest $t))
		else
			case $e in
				hr)o="<$e>";;
				html)o="<!DOCTYPE html>$tag";;
				*)o=$tag;;
			esac
	fi
	echo $o | perl -pe 's/\n//g'
}
void() {
	if [[ -z ${2++} ]]
		then [[ $1 != null ]] || return 1
		else
			if [[ $1 != null ]]
				then echo $1
				else echo $2
			fi
	fi
}
get() {
	echo "$1" | jq -r .$2
}
cap() {
	perl -pe 's|\b(\w)(\w*)\b|\u$1\L$2|g'
}
title="Project: Jekyll"
el html:body $(
	el h1 $title
	el p $(el q $title) is a datapack for $(el q Minecraft: Java Edition 1.21.10). The end-goal is to add many monsters to the game, along with drops that the player consumes to gain their abilities.
	el h2 Features
	el ul $(
		el li Monsters
		el li Items that give the powers of monsters
	)
	el h2 Monsters
	el dl $(
		yml data/data.yml -p yaml -o json \
			| jq -c .[] \
			| while read -r i
		do
			name=$(get "$i" name | cap)
			base=$(get "$i" base | cap)
			blood=$(void $(get "$i" blood) $name | cap)
			abilities=$(get "$i" abilities[] | cap)
			el dt $name
			if void "$base"
				then el dd Based off of $(el code $base)
			fi
			el dd:code $(void $blood $name) Blood
			el dd:ul $(echo "$abilities" | while read -r ability
				do el li $ability
			done)
		done
	)
	el h2 Use
	el p Currently, as there are no mobs to drop these items, they are given at the start. If they "aren't," $(el code /reload) will clear your inventory / potion effects "&" give the items
	el h2 Notes
	el p The name, $(el q $title,) comes from $(el q The Strange Case of Dr. Jekyll "&" Mr. Hyde)
)