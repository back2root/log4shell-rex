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
dollar='(?:\$|(?:%(?:25)*|\\00)24|\\0{0,2}?44)'
curly_open='(?:{|(?:%(?:25)*|\\00)7[Bb]|\\0{0,2}?173)'
colon='(?::|(?:%(?:25)*|\\00)3[Aa]|\\0{0,2}?72)'
slash='(?:\/|(?:%(?:25)*|\\00)2[Ff]|\\0{0,2}?57)'
sp='.{0,30}?'

# Basic Alphabet (some letters are prepared but not yet used)
#Upper|Lower|URL-Encoded&Unicode|Octal
a='(?:A|a|(?:%(?:25)*|\\00)[46]1|\\0{0,2}?1[04]1)'
b='(?:B|b|(?:%(?:25)*|\\00)[46]2|\\0{0,2}?1[04]2)'
c='(?:C|c|(?:%(?:25)*|\\00)[46]3|\\0{0,2}?1[04]3)'
d='(?:D|d|(?:%(?:25)*|\\00)[46]4|\\0{0,2}?1[04]4)'
e='(?:E|e|(?:%(?:25)*|\\00)[46]5|\\0{0,2}?1[04]5)'
#f='(?:F|f|(?:%(?:25)*|\\00)[46]6|\\0{0,2}?1[04]6)'
#g='(?:G|g|(?:%(?:25)*|\\00)[46]7|\\0{0,2}?1[04]7)'
h='(?:H|h|(?:%(?:25)*|\\00)[46]8|\\0{0,2}?1[15]0)'
i='(?:I|i|(?:%(?:25)*|\\00)[46]9|\\0{0,2}?1[15]1|ı)'
j='(?:J|j|(?:%(?:25)*|\\00)[46][Aa]|\\0{0,2}?1[15]2)'
#k='(?:K|k|(?:%(?:25)*|\\00)[46][Bb]|\\0{0,2}?1[15]3)'
l='(?:L|l|(?:%(?:25)*|\\00)[46][Cc]|\\0{0,2}?1[15]4)'
m='(?:M|m|(?:%(?:25)*|\\00)[46][Dd]|\\0{0,2}?1[15]5)'
n='(?:N|n|(?:%(?:25)*|\\00)[46][Ee]|\\0{0,2}?1[15]6)'
o='(?:O|o|(?:%(?:25)*|\\00)[46][Ff]|\\0{0,2}?1[15]7)'
p='(?:P|p|(?:%(?:25)*|\\00)[57]0|\\0{0,2}?1[26]0)'
#q='(?:Q|q|(?:%(?:25)*|\\00)[57]1|\\0{0,2}?1[26]1)'
r='(?:R|r|(?:%(?:25)*|\\00)[57]2|\\0{0,2}?1[26]2)'
s='(?:S|s|(?:%(?:25)*|\\00)[57]3|\\0{0,2}?1[26]3)'
t='(?:T|t|(?:%(?:25)*|\\00)[57]4|\\0{0,2}?1[26]4)'
#u='(?:U|u|(?:%(?:25)*|\\00)[57]5|\\0{0,2}?1[26]5)'
#v='(?:V|v|(?:%(?:25)*|\\00)[57]6|\\0{0,2}?1[26]6)'
#w='(?:W|w|(?:%(?:25)*|\\00)[57]7|\\0{0,2}?1[26]7)'
#x='(?:X|x|(?:%(?:25)*|\\00)[57]8|\\0{0,2}?1[37]0)'
#y='(?:Y|y|(?:%(?:25)*|\\00)[57]9|\\0{0,2}?1[37]1)'
#z='(?:Z|z|(?:%(?:25)*|\\00)[57][Aa]|\\0{0,2}?1[37]2)'

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
b64="${b}${sp}${a}${sp}${s}${sp}${e}.{2,60}?${colon}${b64_enc}"

plain="${jndi}${sp}${colon}${sp}${protocols}${sp}${colon}${sp}${slash}"

Log4ShellRex="${dollar}${curly_open}${sp}(${plain}|${b64})"

echo "Log4ShellRex='${Log4ShellRex}'"
