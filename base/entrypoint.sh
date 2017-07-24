#!/bin/bash

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value

    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/_/g; s/_/./g'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty /etc/hbase/$module-site.xml $name "$value"
    done
}

configure /etc/hbase/hbase-site.xml hbase HBASE_CONF

function setRegionServers() {
  cat > /etc/hbase/regionservers
  for regionServer in $REGION_SERVERS; do
    echo $regionServer >> /etc/hbase/regionservers
  done
}

setRegionServers

function setBackupMasters() {
  cat > /etc/hbase/backup-masters
  for backupMaster in $BACKUP_MASTERS; do
    echo $backupMaster >> /etc/hbase/backup-masters
  done
}

setBackupMasters

exec $@
