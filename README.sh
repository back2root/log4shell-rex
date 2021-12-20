#!/bin/bash

#   _                _  _  ____  _          _ _       ____
#  | |    ___   __ _| || |/ ___|| |__   ___| | |     |  _ \ _____  __
#  | |   / _ \ / _` | || |\___ \| '_ \ / _ \ | |_____| |_) / _ \ \/ /
#  | |__| (_) | (_| |__   _|__) | | | |  __/ | |_____|  _ <  __/>  <
#  |_____\___/ \__, |  |_||____/|_| |_|\___|_|_|     |_| \_\___/_/\_\
#              |___/
#
#  2021-12-13 back2root https://github.com/back2root

eval "$(./RegEx_Generator.sh "${1}")"

echo "Documentation printed in Markdown format to stdout" >&2
echo "Use \`./README.sh > README.md\` to update README.md" >&2

# shellcheck disable=SC2154
cat << EOF
# Log4Shell-Rex

The following RegEx was written in an attempt to match indicators of a Log4Shell (CVE-2021-44228 and
CVE-2021-45046) exploitation.

**If you run a version from pre 2021/12/21, it's highly recommended to test and update.**\\
I've removed some quirks and enhanced performance.

The Regex aims being PCRE compatible, but should also run on re2 and potentially more RegEx engines.

**RegEx:**
\`\`\`regex
${Log4ShellRex}
\`\`\`

## Capabilities

By now, this regex should match the exploit, regardless:

- Just logged
- Case insensitive (also in all supported encodings)
- URL Encoded
- Recursively URL Encoded
- With Unicode encoding
- With Octal encoding
- Base64 encoded (rudimentary)

### Background

The goal is to have a RegEx that represents a reasonable tradeoff between detecting as many attack
attempts as possible with an acceptable number of false positives.

The APT attacker will find a way around if necessary, but less elaborate attacks will leave the
warning light on.

Why a (single) RegEx: Because it can be easily executed on the CLI or in a SIEM without any
additional tools. If tools can be executed, do it, they exist.

The length of the regex is less of a problem than its performance. Despite the length, the RegEx
should be acceptably fast to execute on average log data.

### Call for action

I wanna make it hard to hide an attack in real world szenarios.

If this RegEx does not match sth. you have seen in the wild or can show being exploitable, please
create an issue.

It is known, that you can work around the RegEx easily by encoding different parts of the attack
pattern using Base64. How ever, this is accepted, as \`base64\` did not finaly made it into an
official Log4j release yet. ([LOG4J2-2446](https://issues.apache.org/jira/projects/LOG4J2/issues/LOG4J2-2446))

### Tools

- Test the RegEx: **[regex101](https://regex101.com/r/KqGG3W/24)**
- Visualize the Regex: **[REGEXPER](https://regexper.com/#%28%3F%3A%5E%7C%5B%5Cn%5D%29.*%3F%28%3F%3A%5B%5Cx24%5D%7C%25%28%3F%3A25%25%3F%29*24%7C%5C%5Cu%3F0*%28%3F%3A44%7C24%29%29%28%3F%3A%5B%5Cx7b%5D%7C%25%28%3F%3A25%25%3F%29*7b%7C%5C%5Cu%3F0*%28%3F%3A7b%7C173%29%29%5B%5E%5Cn%5D*%3F%28%28%3F%3Aj%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A4a%7C6a%29%7C%5C%5Cu%3F0*%28%3F%3A112%7C6a%7C4a%7C152%29%29%5B%5E%5Cn%5D*%3F%28%3F%3An%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A4e%7C6e%29%7C%5C%5Cu%3F0*%28%3F%3A4e%7C156%7C116%7C6e%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Ad%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A44%7C64%29%7C%5C%5Cu%3F0*%28%3F%3A44%7C144%7C104%7C64%29%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bi%5Cx%7B130%7D%5Cx%7B131%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A49%7C69%7CC4%25%28%3F%3A25%25%3F%29*B0%7CC4%25%28%3F%3A25%25%3F%29*B1%29%7C%5C%5Cu%3F0*%28%3F%3A111%7C69%7C49%7C151%7C130%7C460%7C131%7C461%29%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5B%5Cx3a%5D%7C%25%28%3F%3A25%25%3F%29*3a%7C%5C%5Cu%3F0*%28%3F%3A72%7C3a%29%29%5B%5E%5Cn%5D*%3F%28%28%3F%3Al%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A4c%7C6c%29%7C%5C%5Cu%3F0*%28%3F%3A154%7C114%7C6c%7C4c%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Ad%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A44%7C64%29%7C%5C%5Cu%3F0*%28%3F%3A44%7C144%7C104%7C64%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Aa%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A41%7C61%29%7C%5C%5Cu%3F0*%28%3F%3A101%7C61%7C41%7C141%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Ap%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A50%7C70%29%7C%5C%5Cu%3F0*%28%3F%3A70%7C50%7C160%7C120%29%29%28%3F%3A%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bs%5Cx%7B17f%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A53%7C73%7CC5%25%28%3F%3A25%25%3F%29*BF%29%7C%5C%5Cu%3F0*%28%3F%3A17f%7C123%7C577%7C73%7C53%7C163%29%29%29%3F%7C%28%3F%3Ar%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A52%7C72%29%7C%5C%5Cu%3F0*%28%3F%3A122%7C72%7C52%7C162%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Am%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A4d%7C6d%29%7C%5C%5Cu%3F0*%28%3F%3A4d%7C155%7C115%7C6d%29%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bi%5Cx%7B130%7D%5Cx%7B131%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A49%7C69%7CC4%25%28%3F%3A25%25%3F%29*B0%7CC4%25%28%3F%3A25%25%3F%29*B1%29%7C%5C%5Cu%3F0*%28%3F%3A111%7C69%7C49%7C151%7C130%7C460%7C131%7C461%29%29%7C%28%3F%3Ad%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A44%7C64%29%7C%5C%5Cu%3F0*%28%3F%3A44%7C144%7C104%7C64%29%29%5B%5E%5Cn%5D*%3F%28%3F%3An%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A4e%7C6e%29%7C%5C%5Cu%3F0*%28%3F%3A4e%7C156%7C116%7C6e%29%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bs%5Cx%7B17f%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A53%7C73%7CC5%25%28%3F%3A25%25%3F%29*BF%29%7C%5C%5Cu%3F0*%28%3F%3A17f%7C123%7C577%7C73%7C53%7C163%29%29%7C%28%3F%3An%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A4e%7C6e%29%7C%5C%5Cu%3F0*%28%3F%3A4e%7C156%7C116%7C6e%29%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bi%5Cx%7B130%7D%5Cx%7B131%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A49%7C69%7CC4%25%28%3F%3A25%25%3F%29*B0%7CC4%25%28%3F%3A25%25%3F%29*B1%29%7C%5C%5Cu%3F0*%28%3F%3A111%7C69%7C49%7C151%7C130%7C460%7C131%7C461%29%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bs%5Cx%7B17f%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A53%7C73%7CC5%25%28%3F%3A25%25%3F%29*BF%29%7C%5C%5Cu%3F0*%28%3F%3A17f%7C123%7C577%7C73%7C53%7C163%29%29%7C%28%3F%3A%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bi%5Cx%7B130%7D%5Cx%7B131%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A49%7C69%7CC4%25%28%3F%3A25%25%3F%29*B0%7CC4%25%28%3F%3A25%25%3F%29*B1%29%7C%5C%5Cu%3F0*%28%3F%3A111%7C69%7C49%7C151%7C130%7C460%7C131%7C461%29%29%29%7B2%7D%5B%5E%5Cn%5D*%3F%28%3F%3Ao%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A4f%7C6f%29%7C%5C%5Cu%3F0*%28%3F%3A6f%7C4f%7C157%7C117%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Ap%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A50%7C70%29%7C%5C%5Cu%3F0*%28%3F%3A70%7C50%7C160%7C120%29%29%7C%28%3F%3Ac%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A43%7C63%29%7C%5C%5Cu%3F0*%28%3F%3A143%7C103%7C63%7C43%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Ao%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A4f%7C6f%29%7C%5C%5Cu%3F0*%28%3F%3A6f%7C4f%7C157%7C117%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Ar%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A52%7C72%29%7C%5C%5Cu%3F0*%28%3F%3A122%7C72%7C52%7C162%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Ab%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A42%7C62%29%7C%5C%5Cu%3F0*%28%3F%3A102%7C62%7C42%7C142%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Aa%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A41%7C61%29%7C%5C%5Cu%3F0*%28%3F%3A101%7C61%7C41%7C141%29%29%7C%28%3F%3An%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A4e%7C6e%29%7C%5C%5Cu%3F0*%28%3F%3A4e%7C156%7C116%7C6e%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Ad%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A44%7C64%29%7C%5C%5Cu%3F0*%28%3F%3A44%7C144%7C104%7C64%29%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bs%5Cx%7B17f%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A53%7C73%7CC5%25%28%3F%3A25%25%3F%29*BF%29%7C%5C%5Cu%3F0*%28%3F%3A17f%7C123%7C577%7C73%7C53%7C163%29%29%7C%28%3F%3Ah%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A48%7C68%29%7C%5C%5Cu%3F0*%28%3F%3A110%7C68%7C48%7C150%29%29%28%3F%3A%5B%5E%5Cn%5D*%3F%28%3F%3At%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A54%7C74%29%7C%5C%5Cu%3F0*%28%3F%3A124%7C74%7C54%7C164%29%29%29%7B2%7D%5B%5E%5Cn%5D*%3F%28%3F%3Ap%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A50%7C70%29%7C%5C%5Cu%3F0*%28%3F%3A70%7C50%7C160%7C120%29%29%28%3F%3A%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bs%5Cx%7B17f%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A53%7C73%7CC5%25%28%3F%3A25%25%3F%29*BF%29%7C%5C%5Cu%3F0*%28%3F%3A17f%7C123%7C577%7C73%7C53%7C163%29%29%29%3F%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5B%5Cx3a%5D%7C%25%28%3F%3A25%25%3F%29*3a%7C%5C%5Cu%3F0*%28%3F%3A72%7C3a%29%29%7C%28%3F%3Ab%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A42%7C62%29%7C%5C%5Cu%3F0*%28%3F%3A102%7C62%7C42%7C142%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Aa%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A41%7C61%29%7C%5C%5Cu%3F0*%28%3F%3A101%7C61%7C41%7C141%29%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5Bs%5Cx%7B17f%7D%5D%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A53%7C73%7CC5%25%28%3F%3A25%25%3F%29*BF%29%7C%5C%5Cu%3F0*%28%3F%3A17f%7C123%7C577%7C73%7C53%7C163%29%29%5B%5E%5Cn%5D*%3F%28%3F%3Ae%7C%25%28%3F%3A25%25%3F%29*%28%3F%3A45%7C65%29%7C%5C%5Cu%3F0*%28%3F%3A45%7C145%7C105%7C65%29%29%5B%5E%5Cn%5D*%3F%28%3F%3A%5B%5Cx3a%5D%7C%25%28%3F%3A25%25%3F%29*3a%7C%5C%5Cu%3F0*%28%3F%3A72%7C3a%29%29%28JH%5Bs-v%5D%7C%5B%5Cx2b%5Cx2f-9A-Za-z%5D%5BCSiy%5DR7%7C%5B%5Cx2b%5Cx2f-9A-Za-z%5D%7B2%7D%5B048AEIMQUYcgkosw%5Dke%5B%5Cx2b%5Cx2f-9w-z%5D%29%29)**

## Hunting on your Linux machine

### On the CLI with \`grep\`

\`\`\`bash
eval "\$(./RegEx_Generator.sh)"
grep -P \${Log4ShellRex} <logfile>
\`\`\`

\`\`\`bash
grep -P '${Log4ShellRex}' <logfile>
\`\`\`

### Combine it with \`find\` to recursively scan a (sub-)folder of log files

\`\`\`bash
eval "\$(./RegEx_Generator.sh)"
find /var/log -name "*.log" | xargs grep -P \${Log4ShellRex}
\`\`\`

\`\`\`bash
find /var/log -name "*.log" | xargs grep -P '${Log4ShellRex}'
\`\`\`

## Hunting in your logs using Splunk

You can use this RegEx to search your indexed logs using the \`| regex\`
[SPL](https://docs.splunk.com/Documentation/Splunk/latest/SearchReference/Regex) command

\`\`\`spl
index=<...> sourcetype=<...>
| regex "<Log4ShellRex>"
\`\`\`

\`\`\`spl
index=<...> sourcetype=<...>
| regex "${Log4ShellRex//\\/\\\\}"
\`\`\`

## Screenshot

**regex101**
![Example Screenshot regex101](screenshots/example_4a.png)

**grep -P**
![Example Screenshot Shell](screenshots/example_4b.png)

**Splunk**
![Example Screenshot Splunk](screenshots/example_4c.jpeg)

**Graphical representation of the RegEx**
![Example Screenshot Splunk](screenshots/viz_4.png)
(Created using regexper tool from Jeff Avallone, licensed under 
[CC BY license](https://creativecommons.org/licenses/by/3.0/).)

## Other

**Please create a pull request / issue if you can provide syntax for more systems.**

## Credits

I got help and ideas from:

- [@cyberops](https://twitter.com/cyb3rops) building [log4shell-detector](https://github.com/Neo23x0/log4shell-detector/) that served as an inspiration
- [@karanlyons](https://github.com/karanlyons) providing corpus to test against
EOF
