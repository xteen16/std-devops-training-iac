#!/usr/bin/env bash

set -euf -o pipefail

apt-get autoremove -y
apt-get clean -y

# sync 옵션을 주면 큰 파일이 삭제되기 전에 packer 에서 스크립트를 바로 종료하지 않는다.
sync
