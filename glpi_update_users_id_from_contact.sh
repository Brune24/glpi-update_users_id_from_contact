#!/bin/bash

print_help() {
        if [ "${1}" -eq "0" ]; then
            echo "${0##*/} <table> Look for a match from field contact in ldap_users and update field users_id"
            echo "Most frequent tables are glpi_computer, glpi_monitors, glpi_printers..."
            echo "Example"
            echo "${0##*/} glpi_computers"
            echo "Update ldap_users from devices in table glpi_computers"
        fi
}
print_help
