#!/bin/bash
#create database yaml file for metasploit
#uses linked alias name msfdb for hostname, default postgres port
echo "production:
 adapter: postgresql
 database: $MSF_DB
 username: $MSF_DB_USER
 password: $MSF_DB_PASS
 host: msfdb
 port: 5432
 pool: 75
 timeout: 5" > /etc/database.yml

#create pgpass for psql commands
echo "msfdb:5432:*:postgres:$MSFDB_ENV_POSTGRES_PASSWORD" > /.pgpass
chmod 0600 /.pgpass

# Check if we have already ran this container and created the DB 
if psql --username postgres -d postgres --host msfdb --no-password -lqt | cut -d \| -f 1 | grep -w $MSF_DB; then
    # database exists
    echo "$MSF_DB Already exists"
else
    #Does not exist
    echo "Creating - $MSF_DB"

    #create msfDB user
    psql --username postgres -d postgres --host msfdb --no-password --command \
    "CREATE USER $MSF_DB_USER WITH SUPERUSER PASSWORD '$MSF_DB_PASS';"

    #create msfDB
    psql --username postgres -d postgres --host msfdb --no-password --command \
    "CREATE DATABASE $MSF_DB WITH OWNER $MSF_DB_USER;"
fi

#update metasploit 
/usr/share/metasploit-framework/msfupdate

# if launching interactively...
if ["$MODE" -eq "cli"]
then
    #run msfconsole
    /usr/share/metasploit-framework/msfconsole
elif ["$MODE" -eq "rpc"]
then
    IP_ADD=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`
    echo "msfrpcd listening on $IP_ADD"
    /usr/share/metasploit-framework/msfrpcd -U $MSF_RPCD_USER -P $MSF_RPCD_PASS -f
else
    /bin/bash
fi