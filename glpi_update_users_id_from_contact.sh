#!/bin/bash

#################################################
#Date created: 14/06/2021                       #
#Date modified: 15/06/2021                      #
#Valid on: GLPI 9.5.5 | Data injection 2.9.0    #
#Author: psauliere                              #
#################################################

export MYSQL_PWD=''
declare glpi_table=${1}
declare id_array
declare contact
declare id_user

if [[ "${#}" -eq "0" ]]; then
        echo "${0##*/} <table>"
        echo "Loop through each device in <table> passed as argument,"
        echo "look for a match with the value of field <Alternate username>/<Usager> in the user table,"
        echo "link device to an existing user if there is a match"a
        echo "target tables are most likely:"
        echo "glpi_computers"
        echo "glpi_monitors"
        echo "glpi_printers"
        echo "glpi_phones"
        echo "..."
        echo "Example:"
        echo "${0##*/} glpi_computers"
        echo "Loop through devices in glpi_computers, update field <users_id> if value of <contact> match an existing user in glpi_users."
        exit 0
fi

# 1 Get array with device's id
id_array=$(mysql -uglpi glpi -e "select id from ${glpi_table}")

for i in ${id_array[@]}; do
        # 2 Get "contact" value for each id
        contact=$(mysql -uglpi glpi -sN -e "select contact from ${glpi_table} where id = '${i}'")
        # 3 Look for a match in glpi_users
        id_user=$(mysql -uglpi glpi -sN -e "select id from glpi_users where name = '${contact}'")
        # 4 Update "users_id" if match
        if [[ ! -z "${id_user}" ]]
        then
                mysql -uglpi glpi -e "update ${glpi_table} set users_id = ${id_user} where id = ${i}"
        fi

done
