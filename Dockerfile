FROM        debian:stable-slim
RUN         echo slapd slapd/no_configuration boolean true | /usr/bin/debconf-set-selections && \
            apt-get update && apt-get install --no-install-recommends -y slapd ldap-utils
EXPOSE      389
ADD         docker-entrypoint.sh /
ENTRYPOINT  [ "/docker-entrypoint.sh" ]
