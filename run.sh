#!/bin/bash

# 配置
process_name="topic/local_svr/main.py"
python_path="/Users/coreylin/anaconda3/envs/py3/bin/python"
script_path="/Users/coreylin/Desktop/topic/local_svr/main.py"

# 检查进程是否存在
check() {
    if pgrep -f "${process_name}" > /dev/null; then
        echo "running"
    else
        echo "not running"
    fi
}

# 停止进程
stop() {
    pkill -f "${process_name}" && echo "Process stopped" || echo "Process not running"
}

# 启动进程
start() {
    $python_path $script_path &
    echo "Process started"
}

# 健康检查，但进程不存在时自动拉起
health_check() {
    if ! pgrep -f "${process_name}" > /dev/null; then
        start
    fi
}

# 重启进程
restart() {
    stop
    sleep 3
    start
}

# 显示帮助信息
usage() {
    echo "Usage: $0 {start|stop|check|restart|health_check}"
}

# 主逻辑
case $1 in
    start) start ;;
    stop) stop ;;
    check) check ;;
    restart) restart ;;
    health_check) health_check ;;
    *) echo "Invalid input"; usage ;;
esac
