#!/usr/bin/env bash
set -euo pipefail
shopt -s expand_aliases
alias yq="yq --yaml-fix-merge-anchor-to-spec=true"
exec > README.md
cat << EOF
# Project: Jekyll
\`Project: Jekyll\` is a datapack for \`Minecraft: Java Edition 1.21.10\`.
The end-goal is to add many monsters to The game, along with drops that the player consumes to gain their abilities.
## Features
- [ ] Monsters
- [x] Items that give the powers of monsters
## Monsters
$(
	echo "$(
		yq data.yml \
			-p yaml \
			-o json \
			| jq "del(.[0])"
	)" \
		| jq -c ".[]" \
		| while read -r i
	do
		name="$(echo "$i" | jq -r ".name")"
		echo "- [$(
			case "$(echo "$i" | jq -r ".mob")" in
				true)echo "x";;
				*)echo " ";;
			esac
		)] $name$(
			base="$(echo "$i" | jq -r .base)"
			if ! [[ -z "$base" ]]; then
				echo " (Based off of \`$base\`)"
			fi
		)"
		echo -e "\t- \`$(
			b_="$(echo "$i" | jq -r ".blood")"
			if [[ -z "$b_" ]]; then
				echo "$name"
			else
				echo "$b_"
			fi
		) Blood\`"
		ab="$(echo "$i" | jq -r ".abilities[]")"
		echo "$ab" | while read -r a; do
			echo -e "\t\t- $a"
		done
	done
)
## Use
Currently, as there are no mobs to drop these items, they are given at the start.
If they aren't, \`/reload\` will clear your inventory / potion effects & give the items
***
## Notes
The name, \`Project: Jekyll\`, comes from \`The Strange Case of Dr. Jekyll & Mr. Hyde\`
EOF