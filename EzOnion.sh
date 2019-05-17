#!/bin/bash
# https://github.com/Simulink01/EzOnion
# THIS SCRIPT IS NOT FINISHED, DO NOT USE YET.
# Copyright (c) 2019 Simulink. Released under the GNU General Public Lisence v3.0. (https://www.gnu.org/licenses/gpl-3.0.en.html)

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	echo "This script needs to be run with bash, not sh"
	exit
fi

# Make sure script is running as root
if [[ "$EUID" -ne 0 ]]; then
 echo "Sorry, you need to run script this as root."
 exit
fi

# Confimation function
prompt_confirm() {
  while true; do
    read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
    case $REPLY in
      [yY]) echo ; return 0 ;;
      [nN]) echo ; return 1 ;;
      *) printf " \033[31m %s \n\033[0m" "invalid input"
    esac
  done
}

# Compatability Check
DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|arch)' | uniq )
if [ -z $DISTRO ]; then
    DISTRO='unknown'
fi
echo "Detected Distro: $DISTRO"
if [ $DISTRO == 'ubuntu' ] || [ $DISTRO == 'debian' ]
then
	echo "✔️ Your distro is compatable with this script!"
else
	echo "❌ Unfortunatly, your distro is NOT compatable with this script."
	echo "If you would like to see this script work with your distro you can help by contributing."
	exit
fi

# Confirmation 1
echo "This script will make your computer into a TOR relay!"
echo ""
echo "It is required that a Tor relay be allowed to use a minimum of 100 GByte of outbound traffic (and the same amount of incoming traffic) per month. Note: That is only about 1 day worth of traffic on a 10 Mbit/s (Mbps) connection. More (>2 TB/month) is better and recommended"
echo "Please read the legal considorations of running a TOR relay, especially a exit relay."
echo "https://trac.torproject.org/projects/tor/wiki/TorRelayGuide#Partthree:legalinfosocialinfoandmoreresources"
prompt_confirm "Install?" || exit 0

# Security Setup
echo "Setting up Automatic Software Updates.. (Increases Security)"
echo ""
echo ""
apt-get --yes install unattended-upgrades apt-listchanges
# TODO: https://trac.torproject.org/projects/tor/wiki/TorRelayGuide/DebianUbuntuUpdateshttps://trac.torproject.org/projects/tor/wiki/TorRelayGuide/DebianUbuntuUpdates
# TODO: https://trac.torproject.org/projects/tor/wiki/TorRelayGuide

# EOF #
