#! /bin/sh

set -e

GIT_ROOT="$(dirname "$(dirname "$(realpath "$0")")")"

map_color() {
    passed="$1"
    total="$2"
    value="$(echo "${passed} / ${total}" | bc -l)"

    if [ "$(echo "$value < 0.33" | bc)" -eq 1 ]
    then
        echo red
    elif [ "$(echo "$value < 0.66" | bc)" -eq 1 ]
    then
        echo orange
    elif [ "$(echo "$value != 1" | bc)" -eq 1 ]
    then
        echo yellow
    else
        echo brightgreen
    fi
}

debian="$(docker run \
       --interactive \
       --tty \
       --rm \
       --mount src="${GIT_ROOT}",target=/project/,type=bind \
       --workdir /project \
       debian:stretch \
       sh -c "apt-get update && apt-get install -y make nodejs && make test 2>&1" | \
       tee /dev/tty)"

mkdir -p test-results

for test in debian
do
    eval "content=\${${test}}"
    passed="$(echo "${content}" | perl -ne 'print if s/^Tests:.*(\d+) passed.*$/$1/g')"
    total="$(echo "${content}" | perl -ne 'print if s/^Tests:.*(\d+) total.*$/$1/g')"
    color="$(map_color "${passed}" "${total}")"

    cat > "test-results/${test}.json" <<EOF
{
  "schemaVersion": 1,
  "label": "shellshot",
  "message": "${passed} / ${total} tests",
  "color": "${color}",
  "isError": true
}
EOF
done
