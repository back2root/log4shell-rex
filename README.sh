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

**If you run a version from pre 2021/12/20, it's highly recommended to test and update.**\\
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

### Screenshot

![Example Screenshot](screenshots/example_3.png)

Test on:
- **[regex101](https://regex101.com/r/KqGG3W/21)**
- **[CyberChef](https://gchq.github.io/CyberChef/#recipe=Regular_expression('User%20defined','put%20the%20regex%20here',true,true,false,false,false,false,'Highlight%20matches')&input=UHV0IFlvdXIgSW5wdXQgSGVyZQ)**


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

## Other

**Please create a pull request / issue if you can provide syntax for more systems.**

## Credits

I got help and ideas from:

- [@cyberops](https://twitter.com/cyb3rops) building [log4shell-detector](https://github.com/Neo23x0/log4shell-detector/) that served as an inspiration
- [@karanlyons](https://github.com/karanlyons) providing corpus to test against
EOF
