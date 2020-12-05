#!/bin/bash

set -e

# if no ldap configuration then reconfigure slapdsl
if [ ! -d "/etc/ldap/slapd.d" ]; then
  echo "Configuring slapd..."
  cat <<- EOF | debconf-set-selections
slapd	slapd/no_configuration  boolean false
slapd	slapd/domain            string ${SLAPD_DOMAIN:=example.com}
slapd	shared/organization     string ${SLAPD_ORGANIZATION:=myorg}
slapd	slapd/password2         password ${SLAPD_PASSWORD:=secret}
slapd	slapd/password1         password ${SLAPD_PASSWORD:=secret}
slapd	slapd/backend           select BDB
slapd	slapd/purge_database    boolean true
slapd	slapd/move_old_database boolean true
EOF
  dpkg-reconfigure -f noninteractive slapd
fi

exec slapd -d none -h "ldap:/// ldapi:///" -u openldap -g openldap
