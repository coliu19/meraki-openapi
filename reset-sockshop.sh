#! /bin/bash
set -x

# If demo/test in other branch (like demo) other master
# git push origin --delete demo
# git branch -d demo
# git checkout -b demo
# git branch -u origin/demo

# host=http://localhost:8081
host=https://devnet-testing.cisco.com
# TODO: cart or carts
services=( "cart" "catalogue" "payment" "user" "order")
product_tag="DevRel Wear"

echo "## Prepare services"
for service in ${services[*]}; do

  echo delete "$service"
  apiregistryctl service delete "$service" --debug || true
  echo create "$service"

  printf -v payload '{ "organization_id": "DevNet", "product_tag": "%s", "name_id": "%s", "title": "%s demo", "description": "%s API for demo a microservice communication in sockshop", "contact": {"name": "Engineering Team", "email": "engineering@merchandiseshop.com", "url": "https://testing-developer.cisco.com/api-registry/reports?service=%s"}, "analyzers_configs": {"drift": {"service_name_id": "%s.sock-shop"}} }' "$product_tag" "$service" "$service" "$service" "$service" "$service"
  apiregistryctl -H "$host" service create --data "$payload" || true
done
apiregistryctl -H "$host" service list

echo "## Upload the v0.0-rev1 specs which are the base raw specs"
for service in ${services[*]}; do
  echo updateload spec for "$service"
  apiregistryctl -H "$host" service uploadspec v0.0-rev1/"$service".json -s "$service" --version v0.0 --revision 1
done

echo "## Upload the v0.0-rev2 specs which are the perfect specs"
for service in ${services[*]}; do
  echo updateload spec for "$service"
  apiregistryctl -H "$host" service uploadspec v0.0-rev2/"$service".json -s "$service" --version v0.0 --revision 2
done
echo "## Finished prepare works"
