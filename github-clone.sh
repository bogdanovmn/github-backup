#!/bin/bash

TMP_DIR=/tmp/github-backup/$$
API_USER=$1
CLONES_DIR=$2/$API_USER/$(date '+%F-%H%M%S')
API_PREFIX=https://api.github.com
API_RESPONSE_FILE=$TMP_DIR/api-last-response
REPOS_LIST=$TMP_DIR/repos
REPOS_NEXT_PAGE_URL=${API_PREFIX}/user/repos

get_repos() {
    while [ "$REPOS_NEXT_PAGE_URL" ] 
    do
        api_call $REPOS_NEXT_PAGE_URL
        `grep clone_url $API_RESPONSE_FILE | cut -d'"' -f4 >> $REPOS_LIST`

        # link: <https://api.github.com/user/6061777/repos?page=2>; rel="next",
        REPOS_NEXT_PAGE_URL=`grep 'link:.*rel="next"' $API_RESPONSE_FILE | cut -d'<' -f2 | cut -d'>' -f1`
        if [ $REPOS_NEXT_PAGE_URL ]
        then
            info "Next page: $REPOS_NEXT_PAGE_URL"
        fi
    done
}

clone_repo() {
    local git_url=`echo $1 | sed "s,https://,https://$API_USER:$GHT@,"`
    git clone --mirror $git_url 2> /dev/null
    if [ "$?" -ne "0" ]
    then
        error "can't clone"
    fi
}

log() {
    echo "[$(date '+%F %T')] $1 $2"
}

info() {
    log "INFO $1"
}

error() {
    log "ERROR $1"
}

api_call() {
    local url=$1
    local curl_cmd="curl -s -i -u $API_USER:$GHT $url"

    info "Calling $url..."
    `$curl_cmd > $API_RESPONSE_FILE`
}


# Here we go

mkdir -p $TMP_DIR
mkdir -p $CLONES_DIR
get_repos 
cd $CLONES_DIR
for repo in `cat $REPOS_LIST`
do
    log "Copying $repo"
    clone_repo $repo

done
info "Done"
