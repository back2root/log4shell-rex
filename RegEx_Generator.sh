#!/bin/bash
set -e

#   _                _  _  ____  _          _ _       ____
#  | |    ___   __ _| || |/ ___|| |__   ___| | |     |  _ \ _____  __
#  | |   / _ \ / _` | || |\___ \| '_ \ / _ \ | |_____| |_) / _ \ \/ /
#  | |__| (_) | (_| |__   _|__) | | | |  __/ | |_____|  _ <  __/>  <
#  |_____\___/ \__, |  |_||____/|_| |_|\___|_|_|     |_| \_\___/_/\_\
#              |___/
#
#  2021-12-13 @back2root

base64 -d <<< "IF8gICAgICAgICAgICAgICAgXyAgXyAgX19fXyAgXyAgICAgICAgICBfIF8gICAgICAgX19fXwp8IHwgICAgX19fICAgX18gX3wgfHwgfC8gX19ffHwgfF9fICAgX19ffCB8IHwgICAgIHwgIF8gXCBfX19fXyAgX18KfCB8ICAgLyBfIFwgLyBfYCB8IHx8IHxcX19fIFx8ICdfIFwgLyBfIFwgfCB8X19fX198IHxfKSAvIF8gXCBcLyAvCnwgfF9ffCAoXykgfCAoX3wgfF9fICAgX3xfXykgfCB8IHwgfCAgX18vIHwgfF9fX19ffCAgXyA8ICBfXy8+ICA8CnxfX19fX1xfX18vIFxfXywgfCAgfF98fF9fX18vfF98IHxffFxfX198X3xffCAgICAgfF98IFxfXF9fXy9fL1xfXAogICAgICAgICAgICB8X19fLwoK" >&2

# Build Alphabet if requested
if [ "${1}" == "-buildAlphabet" ]; then
  javac=$(command -v javac) || exit 1
  java=$(command -v java) || exit 1

  ${javac} Alphabet.java
  ${java} "Alphabet" > Alphabet
fi

sp='[^\n]*?'
source "Alphabet"

# String groups
jndi="${j}${sp}${n}${sp}${d}${sp}${i}"

ldaps="${l}${sp}${d}${sp}${a}${sp}${p}(?:${sp}${s})?"
rmi="${r}${sp}${m}${sp}${i}"
dns="${d}${sp}${n}${sp}${s}"
nis="${n}${sp}${i}${sp}${s}"
iiop="(?:${sp}${i}){2}${sp}${o}${sp}${p}"
corba="${c}${sp}${o}${sp}${r}${sp}${b}${sp}${a}"
nds="${n}${sp}${d}${sp}${s}"
https="${h}(?:${sp}${t}){2}${sp}${p}(?:${sp}${s})?"

# Target RegEx
# ${jndi:(ldap[s]?|rmi|dns|nis|iiop|corba|nds|http):

protocols="(${ldaps}|${rmi}|${dns}|${nis}|${iiop}|${corba}|${nds}|${https})"

b64_enc='(JH[s-v]|[\x2b\x2f-9A-Za-z][CSiy]R7|[\x2b\x2f-9A-Za-z]{2}[048AEIMQUYcgkosw]ke[\x2b\x2f-9w-z])'
b64="${b}${sp}${a}${sp}${s}${sp}${e}${sp}${colon}${b64_enc}"

plain="${jndi}${sp}${colon}${sp}${protocols}${sp}${colon}"

Log4ShellRex="(?im)(?:^|[\n]).*?${dollar}${curly_open}${sp}(${plain}|${b64})"

echo "Log4ShellRex='${Log4ShellRex}'"
