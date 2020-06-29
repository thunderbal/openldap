# openldap

## Utilisation avec docker-compose

'''yaml
version: '3'
services:
  ldap:
    image: thunderball/openldap
    environment:
      SLAPD_DOMAIN: example.com
      SLAPD_ORGANIZATION: myorg
      SLAPD_PASSWORD: "secret"
    ports:
      - 389:389
  lam:
    image: ldapaccountmanager/lam:stable
    ports:
    - 80:80
'''

## Variables

* SLAPD_DOMAIN: nom DNS du domaine LDAP (valeur par défaut : example.com).
* SLAPD_ORGANIZATION: un nom d'organisation (valeur par défaut: myorg).
* SLAPD_PASSWORD: le mot de pass en clair

## Problèmes connus

* Le mot de passe du "cn=admin,dc=..." ne semble pas être initialisé corectement (RESOLU)

## Astuces

Pour réinitialiser le mot de pass du super admin, il faut exécuter les commandes suivantes :

'''
# 1> chiffrer le nouveau mot de passe
slappassword -h SSHA
# 2> encoder le résultat en base64
echo {SSHA]}... | base64
# 3> Pour le modifier dans la base LDAP
ldapmodify -Y EXTERNAL -H ldapi:/// <<- EOF
dn: olcDatabase={1}bdb,cn=config
replace: olcRootPW
olcRootPW: XXXXX

EOF
'''

Remplacer la chaine XXXX par celle obtenu par la 2eme commande.

## A faire

Reconfiguration des dossiers, pour n'avoir qu'un seul volume à gérer (/usr/local)

* /etc/ldap     ==> /usr/local/etc/ldap
* /var/lib/ldap ==> /usr/local/var/lib/ldap
