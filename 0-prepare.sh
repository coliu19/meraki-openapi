#! /bin/bash
set -ex

source ./env.sh
host=${host:-https://devnet-testing.cisco.com}

service=catalogue
product_tag="DevRel Wear"
service_title="$(tr '[:lower:]' '[:upper:]' <<< ${service:0:1})${service:1}"

apiregistryctl -H "$host" service delete "$service" --debug || true

printf -v payload '{ "organization_id": "DevNet", "product_tag": "%s", "name_id": "%s", "title": "%s Demo API", "description": "%s microservice for %s demo application", "contact": {"name": "Engineering Team", "email": "engineering@merchandiseshop.com", "url": "https://app-8081-apiregistry1.devenv-int.ap-ne-1.devnetcloud.com/"}, "analyzers_configs": {"drift": {"service_name_id": "%s.sock-shop"}} }' "$product_tag" "$service" "$service_title" "$service_title" "$product_tag" "$service"

apiregistryctl -H "$host" service create --data "$payload" --debug || true

apiregistryctl -H "$host" service list | grep catalogue

apiregistryctl -H "$host" service uploadspec v0.0-rev1/catalogue.json -s catalogue --version v0.0 --revision 1 --debug
# apiregistryctl -H "$host" service uploadspec v0.0-rev2/catalogue.json -s catalogue --version v0.0 --revision 2 --debug


cp v0.0-rev2/catalogue.json openapi/
# git diff

git add openapi/catalogue.json
git commit -m "perfect catalogue api" || true
git push

./trigger-ci-upload.sh v0.0-2
