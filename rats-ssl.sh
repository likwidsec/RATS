#!/bin/sh
# A small bash script to fire off many of my common enumeration/scanning tools with one command.  Use is fairly straight-forward.
# To-Do:
# - Add SQLMap and Hydra commands.
# - Add some sort of menu or choice type system to run or not run certain scans when run.
# - Make a sandwich.
#
# - Version for scanning targets with SSL.
# - Added a few SSL scans.
# -- likwidsec --

HOST=$1 # Takes first argument as host.
WFUZZWL="/usr/share/wordlists/wfuzz/general/big.txt"
WORDLIST="/usr/share/wordlists/dirbuster/dir-medium.txt" # -- CHANGE THIS IF NEEDED
USERLIST="/usr/share/wordlists/metasploit/unix_users.txt"
PASSLIST="/usr/share/wordlists/rockyou.txt"

#wpscan -
wpscan --enumerate --url https://$HOST/ > wpscan-ssl.$HOST &

#wfuzz -
wfuzz -c -z file,$WFUZZWL --hc 404,500 https://$HOST/FUZZ > wfuzz-ssl.$HOST &

#gobuster -
gobuster -w $WORDLIST -u https://$HOST > gobuster-ssl.$HOST &

#dirb -
dirb https://$HOST $WORDLIST -w -r > dirb-ssl.$HOST &

#uniscan -
uniscan -u https://$HOST/ -qweds > uniscan-ssl.$HOST &

#nikto -
nikto -h https://$HOST -Cgidirs all -ask auto > nikto-ssl.$HOST &

#sslscan
sslscan --show-certificate --verbose $HOST > sslscan.$HOST &

