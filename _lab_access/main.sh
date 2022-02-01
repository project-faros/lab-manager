function describe() {
local env=$1
local subnet="172.17.$(expr ${env:3} + 0)"
local description=$(ipa group-find $env --sizelimit=1 --raw 2> /dev/null | \
	            tail -n +5 | head -n -4 | \
		    sed 's/^  description: //g;s/^/  /g')

echo """
$(tput bold)Environment ${env:3}$(tput sgr0)
$(tput bold)******************************************************************$(tput sgr0)
$description

  $(tput bold)Network Information$(tput sgr0)
  $(tput sitm)Subnet:$(tput sgr0) $subnet.0/24
  $(tput sitm)Gateway:$(tput sgr0) $subnet.1
  $(tput sitm)DNS: 172.16.1.5
  $(tput sitm)DHCP Pool:$(tput sgr0) $subnet.10-100

  $(tput bold)Hub Cluster$(tput sgr0)
  $(tput sitm)Host:$(tput sgr0) hub.$env.faros.site
  $(tput sitm)Console URL:$(tput sgr0) https://console-openshift-console.apps.hub.$env.faros.site
  $(tput sitm)Admin Username:$(tput sgr0) farosadmin
  $(tput sitm)Admin Password:$(tput sgr0) R3dH4tRock\$
  $(tput sitm)Admin Kubeconfig:$(tput sgr0) /home/kubeconfigs/$env/kubeconfig
  $(tput sitm)SSH Private Key:$(tput sgr0) /home/kubeconfigs/$env/id_rsa
  $(tput sitm)SSH Public Key:$(tput sgr0) /home/kubeconfigs/$env/id_rsa.pub

  $(tput bold)Spoke Cluster$(tput sgr0)
  $(tput sitm)Chassis Manager:$(tput sgr0) https://cm.$env.faros.site
  $(tput sitm)Node 0 iLO:$(tput sgr0) https://node-0-mgmt.$env.faros.site
  $(tput sitm)Node 1 iLO:$(tput sgr0) https://node-1-mgmt.$env.faros.site
  $(tput sitm)Node 2 iLO:$(tput sgr0) https://node-2-mgmt.$env.faros.site
  $(tput sitm)Node 3 iLO:$(tput sgr0) https://node-3-mgmt.$env.faros.site
  $(tput sitm)iLO Admin Username:$(tput sgr0) farosadmin
  $(tput sitm)iLO Admin Password:$(tput sgr0) R3dH4tRock\$

"""
}

function list() {
groups | egrep -o 'env[[:digit:]]+'
}

function usage() {
echo """USAGE: lab access [ENV_NAME]

Retrieve access credentials for environments for which you have access.

Populate ENV_NAME with an environment name to see environment credentials.
Set ENV_NAME to all to list credentials for all available environments.
"""
}

if [ "$1" == "all" ]; then
	for env in $(list); do
		describe $env
	done
elif [ "${1:0:3}" == "env" ] && groups | grep "$1" &> /dev/null; then
	describe $1
else
	usage 1>&2
	exit 1	
fi
