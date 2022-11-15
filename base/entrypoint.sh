#!/bin/bash

function setProperty() {
  # Sets/unsets property value in an XML configuration file
  # Usage:
  # * Append/update: `setProperty filePath propName propValue` 
  # * Delete: `setProperty filePath propName` 
  local path=$1
  local name=$2
  local value=$3

  local wrappedName="<name>$name</name>"
  local escapedName=${wrappedName//\//\\/} # https://stackoverflow.com/a/27788661
  if [ -z "$value" ]; then
    sed -i "/${escapedName}/d" $path
  else
    local entry="<property>$wrappedName<value>$value</value></property>"
    local escapedEntry=${entry//\//\\/}
    # https://superuser.com/a/590666
    grep -q "${wrappedName}" $path && sed -i "/${escapedName}/c ${escapedEntry}" $path || sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
  fi
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
        setProperty /etc/hbase/$module-site.xml $name "$value"
    done
}

configure /etc/hbase/hbase-site.xml hbase HBASE_CONF

function wait_for_it()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $service $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi

      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $service $port
      result=$?
    done
    echo "[$i/$max_try] $service:${port} is available."
}

for i in "${SERVICE_PRECONDITION[@]}"
do
    wait_for_it ${i}
done

exec $@
