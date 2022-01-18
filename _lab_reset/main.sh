USAGE="""
lab reset ENVIRONMENT

Reset an environment to which you have access back to
the starting condition. This cannot be undone.
"""

source_dir=$(dirname $BASH_SOURCE)
env=$1

if [ ! -f "$source_dir/reset-$env" ]; then
    echo "$USAGE"
    exit 1
fi

read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
	echo ''
        "$source_dir/reset-$env"
        ;;
    *)
	echo 'Canceled'
	exit 1
        ;;
esac
