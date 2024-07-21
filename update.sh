#!/bin/bash

# 获取IP列表文件
wget -O all_cn_cidr.txt https://ispip.clang.cn/all_cn_cidr.txt
wget -O hk.txt https://ispip.clang.cn/hk.txt
wget -O mo.txt https://ispip.clang.cn/mo.txt
wget -O tw.txt https://ispip.clang.cn/tw.txt



# 输入文件路径
cidr_files=("all_cn_cidr.txt" "hk.txt" "mo.txt" "tw.txt")

# 输出RSC文件路径
rsc_file="CN.rsc"

# CN地址列表的名称
address_list="CN"

# 清空输出文件内容
> $rsc_file

# 读取所有TXT文件中的CIDR格式IP地址列表
for cidr_file in "${cidr_files[@]}"; do
  while IFS= read -r cidr_address; do
    # 检查行是否包含 #
    if ! echo "$cidr_address" | grep -q '#'; then
      # 将CIDR地址添加到RSC文件中
      echo "/ip firewall address-list add list=$address_list address=$cidr_address" >> $rsc_file
    fi
  done < "$cidr_file"
done

echo "处理完成，CIDR格式的IP地址已转换为RSC格式并写入 $rsc_file"
