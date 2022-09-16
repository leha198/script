#!/bin/bash
usr="/home/$(whoami)"
src_url="failoverhosting.com.vn"
bk=domain_ins
PS3="Chose domain restore:"
select dm in `ls -l -Ilog -I${domain} | awk '/^d/ {print $9}'`; do
	if [ -d ${dm}/DocumentRoot/wp-content ]; then
            break
        else
            echo "Script only support WordPress..."
            exit 2
        fi
    done

	cd ${usr}/${dm}/DocumentRoot
	admin_pw=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 12`	
    wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O wp
	php74 wp core install --url=${dm} --title=Blog --admin_user=admin --admin_password=${admin_pw} --admin_email=tenten@gmail.com 2>&1 >/dev/null
	php74 wp option update home "http://${dm}" > /dev/null
	php74 wp option update siteurl "http://${dm}" > /dev/null
	plugin_act
	mv -f ${usr}/${domain}.wpress wp-content/ai1wm-backups/${domain}.wpress
	php74 wp ai1wm restore ${domain}.wpress --yes > /dev/null
	plugin_deact
