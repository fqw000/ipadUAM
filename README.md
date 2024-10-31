# ipadUAM
将ipad作为Mac Mini唯一实体屏幕使用的，解决方案。

# 实现效果
- Mac Mini必须的接线只有一根电源线；
- 提供网页管理页面，支持连接、断开、停止等操作；
- 屏幕连接中断以后支持自动重连

# 实现
1. 修改配置文件`/sidecar/sidecar.applescript`中ipad名称为设备名称；
2. ~~按照实际路径修改各sh、py文件中的路径；~~
3. sidecar.app：使用Mac 脚本编辑器 导出到应用目录；
4. ipadUAM.app：自动化操作中新建应用程序；
5. 给予3、4步文件开启辅助功能、登录自启动权限；
6. 安装betterdisplay创建一个虚拟屏幕，设置"ipad为主屏幕"，虚拟屏幕为 "ipad镜像"；
7. 配置ipad自动登录，能配置apple watch解锁更好，没有apple watch的锁屏以后盲输密码就好了；
8. 注意这里只是调整了Mac屏幕在ipad显示，声音还是在Mac Mini上，建议使用蓝牙音响体验效果会更好。
# 管理页面
所有配置在Mac端完成，ipad端管理页面地址为`Mac Mini ip:80` (默认使用了80端口，端口在配置文件`main.py`中按需调整)


