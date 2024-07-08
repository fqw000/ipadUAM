#!/bin/bash

# 配置
SIDECAR_DIR="/Users/coreylin/Desktop/topic/sidecar"
SH_FILE="$SIDECAR_DIR/run_sidecar.sh"
LOG_FILE="$SIDECAR_DIR/debug.log"

# 功能函数
check() {
    pgrep -f "${process_name}" > /dev/null && echo "running" || echo "not running"
}

stop() {
    pkill -f "${process_name}" && echo "Process stopped" || echo "Process not running"
}

start() {
    /bin/sh "$SH_FILE" > "$LOG_FILE" 2>&1 &
    echo "Process started"
}

health_check() {
    pgrep -f "${process_name}" > /dev/null || start
}

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