import functools
import pywebio
from pywebio.input import *
from pywebio.output import *
from pywebio.session import *
from tornado.web import create_signed_value, decode_signed_value
from lib.sidecar import SidecarTask

# 定义根目录路径
BASE_DIR = "/Users/coreylin/Desktop/topic/sidecar"

class LocalStorage:
    @staticmethod
    def set(key, value):
        run_js("localStorage.setItem(key, value)", key=key, value=value)

    @staticmethod
    def get(key):
        return eval_js("localStorage.getItem(key)", key=key)

    @staticmethod
    def remove(key):
        run_js("localStorage.removeItem(key)", key=key)

# 定义一个装饰器，用于检查用户是否已登录
def login_required(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        token = LocalStorage.get('token')
        username = decode_signed_value(SECRET, 'token', token, max_age_days=7)
        if not token or not username:
            return login()
        return func(*args, **kwargs)
    return wrapper

def check_user(username, password):
    # 检查用户名密码是否正确
    return username == "admin" and password == "admin"

# 加盐
SECRET = "encryption salt value"

def login():
    """用户登录"""
    user = input_group('Login', [
        input("Username", name='username'),
        input("Password", type=PASSWORD, name='password'),
    ])
    if check_user(user['username'], user['password']):
        signed = create_signed_value(SECRET, 'token', user['username']).decode("utf-8")
        LocalStorage.set('token', signed)
        LocalStorage.set('username', user['username'])
        return index()
    else:
        toast('Wrong username or password!', color='error')
        return login()

@login_required
def connect_ipad():
    """连接iPad"""
    SidecarTask.connect_ipad()
    toast("已触发连接 iPad", color="success")
    return index()

@login_required
def disconnect_ipad():
    """断开iPad"""
    SidecarTask.disconnect_ipad()
    toast("已触发断开 iPad", color="success")
    return index()

@login_required
def stop_ipad_task():
    """暂停iPad任务"""
    SidecarTask.disable_task()
    toast("已停止自动重连", color="success")
    return index()

@login_required
def logout():
    """退出登录"""
    LocalStorage.remove('token')
    toast("Logout Success!", color='success')
    clear()
    return index()

@login_required
def index():
    """首页"""
    clear()
    put_markdown("# Welcome to visit MacMini server")
    put_markdown("---")
    put_markdown(f"当前连接状态：{SidecarTask.get_current_status()}")
    put_markdown(f"当前任务配置：{SidecarTask.get_connect_flag()}")
    put_markdown(f"任务开关: {SidecarTask.get_task_status()}")

    options = {
        "连接 iPad": connect_ipad,
        "断开 iPad": disconnect_ipad,
        "关闭自动随航": stop_ipad_task
    }
    selected_option = select("Mac2ipad 自动随航功能", options=options)
    options[selected_option]()

if __name__ == '__main__':
    pywebio.start_server([index, connect_ipad, disconnect_ipad, stop_ipad_task, logout], port=80)