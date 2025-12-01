#!/usr/bin/env bash
set -euo pipefail
shopt -s expand_aliases
flag() {
	for f in "$@"; do
		[[ -e ".flags/$f" ]] || return 1
	done
}
DIRS=(
	bin
	logs
)
DOCS=src/main/docs
for i in "${DIRS[@]}"; do
	rm -rf "$i" || :
	mkdir -p "$i"
done
exec > logs/mod.log 2>& 1
alias gradlew="./gradlew"
cat $DOCS/src/desc.md | perl -p -e 's/\n/\\n/g; s/\t/  /g' > $DOCS/dist/desc.txt
# gradlew clean
gradlew build --info --debug --stacktrace --scan
find build/libs -name "*.jar" -exec cp {} bin/jekyll \;
# if flag local; then
# 	gradlew runClient
# fi