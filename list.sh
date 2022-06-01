#! /bin/bash
set -x

source ./env.sh
host=${host:-https://devnet-testing.cisco.com}

# host=http://localhost:8081
apiregistryctl -H "$host" service list


apiregistryctl -H "$host" spec list
