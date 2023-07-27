#!/bin/bash

DOMAIN=cclaude.dev
SUBDOMAINS="www"
PROTOCOLS="http https"


curl_it () {
    PROTOCOL=$1
    URL=$DOMAIN
    if [ $# -eq 2 ]
    then
        URL=$2.$DOMAIN
    fi

    echo "Trying $URL (${PROTOCOL})"
    curl --proto-default $PROTOCOL -L $URL
    echo -e "\n"
}

if [ "$DOMAIN" = "default.com" ]; then
    echo "Replace 'default.com' with your own domain !"
    exit
else
    for PROTOCOL in $PROTOCOLS; do
        curl_it $PROTOCOL
        for SUBDOMAIN in $SUBDOMAINS; do
            curl_it $PROTOCOL $SUBDOMAIN
        done
    done
fi
