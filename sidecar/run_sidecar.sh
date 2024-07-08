# 设置路径变量
SIDECAR_DIR="/Users/coreylin/Desktop/topic/sidecar"
COUNT_FILE="$SIDECAR_DIR/num"
CONNECT_FLAG_FILE="$SIDECAR_DIR/connect_flag"

# 检查Sidecar显示器
check_sidecar_display() {
    /usr/sbin/system_profiler SPDisplaysDataType | grep -c "Sidecar Display"
}

# 更新失败计数
update_failure_count() {
    local num=$(<"$COUNT_FILE")

    if (( num > 5 )); then
        echo "连续失败超过5次，不再尝试"
        return 1
    fi

    echo $((num + 1)) > "$COUNT_FILE"
}

# 重置失败计数
reset_failure_count() {
    echo "0" > "$COUNT_FILE"
}

# 连接iPad
connect_ipad() {
    echo "===== connect_ipad ======"
    local flag=$(check_sidecar_display)

    if (( flag == 0 )); then
        echo "未连接 iPad，尝试连接..."
        osascript /Applications/sidecar.app
        sleep 5
        flag=$(check_sidecar_display)
    fi

    if (( flag == 1 )); then
        echo "连接成功，失败计数器清零"
        reset_failure_count
    else
        echo "连接失败，失败计数器加一"
        update_failure_count
    fi

    echo "===== end connect_ipad ======"
}

# 断开iPad
disconnect_ipad() {
    echo "===== disconnect_ipad ======"
    local flag=$(check_sidecar_display)

    if (( flag == 1 )); then
        echo "已连接 iPad，尝试断开..."
        osascript /Applications/sidecar.app
        sleep 5
        flag=$(check_sidecar_display)
    fi

    if (( flag == 0 )); then
        echo "断开成功，失败计数器清零"
        reset_failure_count
    else
        echo "断开失败，失败计数器加一"
        update_failure_count
    fi

    echo "===== end disconnect_ipad ======"
}

# 主循环
while true; do
    exp_flag=$(<"$CONNECT_FLAG_FILE")
    echo "exp_flag $exp_flag"
    if (( exp_flag == 1 )); then
        connect_ipad
    else
        disconnect_ipad
    fi
    sleep 5
done