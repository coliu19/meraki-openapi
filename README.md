# Guide

## Action Required

1. Download the latest cli from the our internal github repo per your OS. Checkout to develop branch. If you use Mac, you can get your binary from cli/bin/darwin/amd64.
2. Copy the binary to your system PATH, and make it executable. For example:
```
cp apiregistryctl /usr/local/bin
chmod +x /usr/local/bin/apiregistryctl
```
3. Clone this repo or fork this repo, make sure you have write access to it. If you forked this repo, you need to enable github actions by going to that tab by yourself.

## Demo

You can simply follow the below steps to demo in staging without viewing other parts of the document.

```
0-prepare.sh
1-add-violations.sh
2-fix-violations.sh
```

## folders

```
v0.0-rev1: raw spec
v0.0-rev2: perfect spec
v0.1-rev1: add some violations against perfect spec
v0.1-rev2: fix all the issues in v0.1-rev1
```

## scripts

* Reset all services in sockshop
```
./reset-sockshop.sh
```
* Delete one or more services by specify some keywords. (Be careful, This is global match, so use some keyword that match your purpose).
```
./delete.sh my-special-servce
```

## workflow explaination

0. Prepare catalogue service(delete and recreate), upload raw spec v0.0-rev1 and perfect spec v0.0-rev2. If you use other env, you need to change the host of the script.
```
./0-prepare.sh
```
1. Change the catalogue.json in openapi folder by copying the same files in other version folders. This add some violations. Commit the change. This will trigger the analyze and upload spec.
```
./1-add-violations.sh
```
    Go the github workflow to view the CI result.
    Then go to UI to view the uploaded version.
2. Fix the broken spec and commit change.
```
./2-fix-violations.sh
```
    Go the github workflow to view the CI result.
    Then go to UI to view the uploaded version.

## Useful commands

* apiregistryctl
```
apiregistryctl analyze v0.1-rev1/catalogue.json
apiregistryctl diff v0.1-rev1/catalogue.json -s catalogue --version v0.0 --revision 2 -o text --fail-on-incompatible
apiregistryctl service uploadspec v0.0-rev2/catalogue.json -s catalogue --version v0.0 --revision base
```

## Trouble shoot

* Press `q` to quit the `git diff` view when running the script if it stuck. (Actually now `git --no-pager diff` can solve this, but we may not use the `no-pager` tag on some situation).

