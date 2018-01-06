#!/bin/sh
# A small bash script to fire off many of my common enumeration/scanning tools with one command.  Use is fairly straight-forward.
# To-Do:
# - Add SQLMap and Hydra commands.
# - Add some sort of menu or choice type system to run or not run certain scans when run.
# - Make a sandwich.
# -- likwidsec --
#
# -- 10/27/17 -- Now the script takes 1 argument - the host.  No more editing every time.
# -- 11/??/17 -- The modified (-dp) script now takes 2 arguments - the host and the port. Used for using tools on diff ports.

HOST=$1
PORT=$2
WFUZZWL="/usr/share/wordlists/wfuzz/general/big.txt"
WORDLIST="/usr/share/wordlists/dirbuster/dir-medium.txt" # -- CHANGE THIS IF NEEDED
USERLIST="/usr/share/wordlists/metasploit/unix_users.txt"
PASSLIST="/usr/share/wordlists/rockyou.txt"

#wpscan -
wpscan --enumerate --threads 16 --url http://$HOST:$PORT/ > wpscan.$HOST-p$PORT &

#wfuzz -
wfuzz -c -z file,$WFUZZWL --hc 404,500 -t 16 http://$HOST:$PORT/FUZZ > wfuzz.$HOST-p$PORT &

#gobuster -
gobuster -w $WORDLIST -u http://$HOST:$PORT -t 16 -v > gobuster.$HOST-p$PORT &

#dirb -
dirb http://$HOST:$PORT $WORDLIST -w -r > dirb.$HOST-p$PORT &

#uniscan -
uniscan -u http://$HOST:$PORT/ -bqweds > uniscan.$HOST-p$PORT &

#nikto -
nikto -h $HOST -p $PORT -Cgidirs all -ask auto -output nikto.$HOST-p$PORT.txt > nikto.$HOST-p$PORT &
