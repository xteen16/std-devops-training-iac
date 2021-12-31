#!/usr/binenv sh

# --private-key=.. 옵션을 통해 pem 키 적용 가능

ansible -i vars.inv all -m ping # ping module 은 해당 리소스 내 파이썬이 사용 가능한지 질의
ansible -i vars.inv amazon -m command -a "uptime" 
ansible localhost -m setup
ansible localhost -m setup -a "filter=ansible_dist*"
ansible -i vars.inv -m apt -a "name=git state=latest update_cache=yes" ubuntu # git update
ansible -i vars.inv -m apt -a "name=git state=latest update_cache=yes" ubuntu --become # become 명령은 root 사용자로 전환
ansible -i vars.inv -m apt -a "name=git state=absent update_cache=yes" ubuntu --become # git 삭제
