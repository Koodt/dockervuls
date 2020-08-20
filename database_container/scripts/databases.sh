cd /vuls/db
for i in `seq 2017 $(date +"%Y")`; do go-cve-dictionary fetchnvd -years $i; done
goval-dictionary fetch-ubuntu 14 16 18 19 207
gost fetch debian
go-exploitdb fetch exploitdb
go-msfdb fetch msfdb
