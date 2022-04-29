#!/bin/bash
# 
TOKEN=$1
PASS=$2

echo $PASS

curl -k -H "Content-Type: application/json" \
     -H "Authorization: Bearer $TOKEN" \
     -X POST -d '{
      "image": "linode/ubuntu20.04",
      "root_pass": "'"${PASS}"'",
      "booted": true,
      "label": "UBULAB_SERVER",
      "type": "g6-nanode-1",
      "region": "eu-west",
      "stackscript_id": 1003346,
      "authorized_keys": [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAvXSIzRBV/NpdctgwJkdeL8IskEjfY7UI5FM5gfBm8iF0X8LfUsmcFnI9nWq+XdE+klzZd+OtM4mcCD0ajEERYhr9RuaqRMeQjoWX0hHO57LkemCm6XLou+eLA4y1Nsh+m8dFy5tn47K+jOeEJyiTpWfQKOunZ6gW4BIDVN4NNGmAlxIWmYX36HuCVHRY3EGPxSYM1tJ9QFfuaI/tDhgvuONz12KFgWn1TtZfPE1FvrSDWwl7mKLb2iTn98pZsv2SxE9VuuIx9xhdtYQotfiPlWnlDCy3L+CF0M2wERrAIYPPXCPtnkbPhdnFicH5aWTUVqu7jtToMT7cUiwEgP6Juw== rsa-key-20220419"
      ]     
    }' \
    https://api.linode.com/v4/linode/instances 

    curl -k -H "Authorization: Bearer $TOKEN" \
    https://api.linode.com/v4/linode/instances > /dev/null