#! /bin/bash

set -o errexit
set -o nounset
set -o pipefail

HYPERSTART_RELEASE=$(grep AC_INIT configure.ac |sed -e "s/.*hyperstart\], \[\(.*\)\], \[.*/\1/")

# build
./autogen.sh
./configure
make clean
cov-build --dir cov-int make
tar czvf hyperstart-coverity.tgz cov-int

# upload
curl --form token=${COV_TOKEN_HYPERSTART}\
  --form email=bergwolf@hyper.sh \
  --form file=@hyperstart-coverity.tgz \
  --form version="${HYPERSTART_RELEASE}" \
  --form description="hyperstart manual coverity" \
  https://scan.coverity.com/builds?project=bergwolf/hyperstart

echo "uploaded coverity results of version ${HYPERSTART_RELEASE}"
