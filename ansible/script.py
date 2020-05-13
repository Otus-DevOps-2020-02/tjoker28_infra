#!/usr/bin/python
import json
import os
request = os.popen("gcloud compute instances list | awk '{print  $1, $5}'").read()
ip_dict = {}
for ip in request.split('\n')[1:-1]:
   ip_dict[str(ip.split(' ')[0])] = [str(ip.split(' ')[1])]

data = ip_dict
json_data = json.dumps(data)
print(json_data)
