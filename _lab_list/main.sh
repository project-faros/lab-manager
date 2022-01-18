echo 'You have access to the following environments.'
echo ''

groups | egrep -o 'env[[:digit:]]+'

echo 'Use *lab access* for credentials.'
