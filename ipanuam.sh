#!/bin/bash

# 激活虚拟环境
source /Users/wangqifei/Documents/ipadUAM/venv/bin/activate

# 执行 Python 脚本
ipaUAM_path="$(pwd)"
python3 ${ipaUAM_path}/main.py
