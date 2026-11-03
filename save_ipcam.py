import getpass, os
user = input("카메라 계정: "); pw = getpass.getpass("비밀번호: ")
path = os.path.expanduser("~/.ipcam")
with open(path, "w") as f: f.write(f"rtsp://{user}:{pw}@192.168.0.144:554\n")
os.chmod(path, 0o600); print("저장:", path)
