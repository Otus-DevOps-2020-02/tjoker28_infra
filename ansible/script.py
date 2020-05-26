#!/usr/bin/python
import json
import os
request = os.popen("gcloud compute instances list | awk '{print  $1, $4, $5}'").read()

ip_list = {"app":{}, "db":{}}
for ip in request.split('\n')[1:-1]:
    if str(ip.split(' ')[0]).endswith("app"):
         ip_list["app"]["hosts"]=[str(ip.split(' ')[2])]
    else:
         ip_list["db"]["hosts"]=[str(ip.split(' ')[2])]
         ip_list["app"]["vars"]={"db_ip":str(ip.split(' ')[1])}

data = ip_list


json_data = json.dumps(data)
print(json_data)
