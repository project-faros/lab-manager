echo 'You have access to the following environments:'
groups | egrep -o 'env[[:digit:]]+' | sed 's/^/  - /g'
echo "Use $(tput sitm)lab access$(tput sgr0) for credentials."
