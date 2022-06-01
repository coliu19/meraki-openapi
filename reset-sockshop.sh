#! /bin/bash
set -x

source ./env.sh
host=${host:-https://devnet-testing.cisco.com}

# If demo/test in other branch (like demo) other master
# git push origin --delete demo
# git branch -d demo
# git checkout -b demo
# git branch -u origin/demo

# TODO: cart or carts
services=( "cart" "catalogue" "payment" "user" "order")
product_tag="DevRel Wear"

echo "## Prepare services"
for service in ${services[*]}; do
  # upper case first char
  service_title="$(tr '[:lower:]' '[:upper:]' <<< ${service:0:1})${service:1}"

  echo delete "$service"
  apiregistryctl -H "$host" service delete "$service" --debug || true
  echo create "$service"

  printf -v payload '{ "organization_id": "DevNet", "product_tag": "%s", "name_id": "%s", "title": "%s Demo API", "description": "%s microservice for %s demo application", "contact": {"name": "Engineering Team", "email": "engineering@merchandiseshop.com", "url": "https://app-8081-apiregistry1.devenv-int.ap-ne-1.devnetcloud.com/"}, "analyzers_configs": {"drift": {"service_name_id": "%s.sock-shop"}} }' "$product_tag" "$service" "$service_title" "$service_title" "$product_tag" "$service"

  apiregistryctl -H "$host" service create --data "$payload" || true
done
apiregistryctl -H "$host" service list

echo "## Upload the v0.0-rev1 specs which are the base raw specs"
for service in ${services[*]}; do
  echo updateload spec for "$service"
  apiregistryctl -H "$host" service uploadspec v0.0-rev1/"$service".json -s "$service" --version v0.0 --revision 1
  sleep 30
done

echo "## Upload the v0.0-rev2 specs which are the perfect specs"
for service in ${services[*]}; do
  echo updateload spec for "$service"
  apiregistryctl -H "$host" service uploadspec v0.0-rev2/"$service".json -s "$service" --version v0.0 --revision 2
  sleep 30
done
echo "## Finished prepare works"
