#!/bin/bash
PASS_FILE="/etc/wireguard/wg.pass"
if [ ! -f $PASS_FILE ]; then /reset-pass.sh; fi

export WG_HOST=${PUBLIC_APP_DOMAIN}
export PASSWORD=$(cat $PASS_FILE)

exec node /root/webapp/server.js