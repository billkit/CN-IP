#!/bin/bash

wget -O chnroutes.txt https://raw.githubusercontent.com/misakaio/chnroutes2/master/chnroutes.txt

# TXT文件的路径
cidr_file="chnroutes.txt"

# RSC文件的路径
rsc_file="CN.rsc"

# CN地址列表的名称
address_list="CN"

# 读取TXT文件中的CIDR格式IP地址列表
while IFS= read -r cidr_address; do
  # 分割CIDR地址为网络和子网掩码
  network=$(echo $cidr_address | cut -d '/' -f 1)
  subnet_mask=$(echo $cidr_address | cut -d '/' -f 2)

  # 创建RSC格式的地址
  rsc_address="${network}/${subnet_mask}"

  # 添加RSC地址到CN地址列表
  echo "/ip/firewall/address-list add address=${rsc_address} list=CN" >> $rsc_file
done < $cidr_file
