from baselib import system

class SidecarTask(object):
    BASE_DIR = "/Users/coreylin/Desktop/topic/sidecar"
    TASK_STATUS_PATH = f"{BASE_DIR}/num"
    CONNECT_FLAG_PATH = f"{BASE_DIR}/connect_flag"
    SCRIPT_PATH = f"{BASE_DIR}/run.sh"

    @classmethod
    def run_sidecar(cls, action="health_check"):
        system.run_cmd(f"sh {cls.SCRIPT_PATH} {action}")

    @classmethod
    def read_num(cls, filename):
        with open(filename, "r") as fid:
            return int(fid.read().strip())

    @classmethod
    def write_num(cls, filename, num):
        system.run_cmd(f"echo '{num}' > {filename}")

    @classmethod
    def get_connect_flag(cls):
        return "连接 iPad" if cls.read_num(cls.CONNECT_FLAG_PATH) == 1 else "断开 iPad"

    @classmethod
    def set_connect_flag(cls, connect_flag=True):
        cls.write_num(cls.CONNECT_FLAG_PATH, int(connect_flag))

    @classmethod
    def enable_task(cls):
        cls.write_num(cls.TASK_STATUS_PATH, 0)
        cls.run_sidecar()

    @classmethod
    def disable_task(cls):
        cls.write_num(cls.TASK_STATUS_PATH, 9)
        cls.run_sidecar()

    @classmethod
    def get_task_status(cls):
        return "启用" if cls.read_num(cls.TASK_STATUS_PATH) <= 5 else "禁用"

    @classmethod
    def connect_ipad(cls):
        cls.set_connect_flag(True)
        cls.enable_task()

    @classmethod
    def disconnect_ipad(cls):
        cls.set_connect_flag(False)
        cls.enable_task()

    @classmethod
    def get_current_status(cls):
        out = system.run_cmd('/usr/sbin/system_profiler SPDisplaysDataType | grep "Sidecar Display" | wc -l')
        return "已连接" if int(out[0].strip()) == 1 else "未连接"