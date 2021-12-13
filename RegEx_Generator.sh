#!/bin/bash

#   _                _  _  ____  _          _ _       ____
#  | |    ___   __ _| || |/ ___|| |__   ___| | |     |  _ \ _____  __
#  | |   / _ \ / _` | || |\___ \| '_ \ / _ \ | |_____| |_) / _ \ \/ /
#  | |__| (_) | (_| |__   _|__) | | | |  __/ | |_____|  _ <  __/>  <
#  |_____\___/ \__, |  |_||____/|_| |_|\___|_|_|     |_| \_\___/_/\_\
#              |___/
#
#  2021-12-13 @back2root

base64 -d <<< "IF8gICAgICAgICAgICAgICAgXyAgXyAgX19fXyAgXyAgICAgICAgICBfIF8gICAgICAgX19fXwp8IHwgICAgX19fICAgX18gX3wgfHwgfC8gX19ffHwgfF9fICAgX19ffCB8IHwgICAgIHwgIF8gXCBfX19fXyAgX18KfCB8ICAgLyBfIFwgLyBfYCB8IHx8IHxcX19fIFx8ICdfIFwgLyBfIFwgfCB8X19fX198IHxfKSAvIF8gXCBcLyAvCnwgfF9ffCAoXykgfCAoX3wgfF9fICAgX3xfXykgfCB8IHwgfCAgX18vIHwgfF9fX19ffCAgXyA8ICBfXy8+ICA8CnxfX19fX1xfX18vIFxfXywgfCAgfF98fF9fX18vfF98IHxffFxfX198X3xffCAgICAgfF98IFxfXF9fXy9fL1xfXAogICAgICAgICAgICB8X19fLwoK" >&2

# Basic signs
dollar='(?:\$|%(?:25)*24)'
curly_open='(?:{|%(?:25)*7[Bb])'
colon='(?::|%(?:25)*3[Aa])'
slash='(?:\/|%(?:25)*2[Ff])'
sp='.{0,30}?'

# Basic Alphabet (some letters are prepared but not yet used)
a='(?:A|a|%[46]1)'
b='(?:B|b|%[46]2)'
c='(?:C|c|%[46]3)'
d='(?:D|d|%[46]4)'
#e='(?:E|e|%[46]5)'
#f='(?:F|f|%[46]6)'
#g='(?:G|g|%[46]7)'
h='(?:H|h|%[46]8)'
i='(?:I|i|%[46]9)'
j='(?:J|j|%[46][Aa])'
#k='(?:K|k|%[46][Bb])'
l='(?:L|l|%[46][Cc])'
m='(?:M|m|%[46][Dd])'
n='(?:N|n|%[46][Ee])'
o='(?:O|o|%[46][Ff])'
p='(?:P|p|%[57]0)'
#q='(?:Q|q|%[57]1)'
r='(?:R|r|%[57]2)'
s='(?:S|s|%[57]3)'
t='(?:T|t|%[57]4)'
#u='(?:U|u|%[57]5)'
#v='(?:V|v|%[57]6)'
#w='(?:W|w|%[57]7)'
#x='(?:X|x|%[57]8)'
#y='(?:Y|y|%[57]9)'
#z='(?:Z|z|%[57][Aa])'

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
Log4ShellRex="${dollar}${curly_open}${sp}${jndi}${sp}${colon}${sp}${protocols}${sp}${colon}${sp}${slash}"

echo "Log4ShellRex='${Log4ShellRex}'"
