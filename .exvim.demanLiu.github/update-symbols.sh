#!/bin/bash
export DEST="./.exvim.demanLiu.github"
export TOOLS="/root/.vim/tools/"
export TMP="${DEST}/_symbols"
export TARGET="${DEST}/symbols"
sh ${TOOLS}/shell/bash/update-symbols.sh
