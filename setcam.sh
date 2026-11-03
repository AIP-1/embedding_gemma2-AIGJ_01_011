#!/bin/bash
# 카메라 RTSP 계정을 받아 .cam.env에 저장한다. ipcam.py가 파일 변경을 보고 한 번만 다시 연결한다.
cd "$(dirname "$0")"
read -r -p "카메라 아이디: " U
read -rs -p "카메라 비밀번호: " P; echo
U="$U" P="$P" python3 - <<"PY" > .cam.env
import os, urllib.parse as q
e = lambda k: q.quote(os.environ[k], safe="")
print(f"CAM_RTSP=rtsp://{e("U")}:{e("P")}@192.168.0.144:554/stream1")
PY
chmod 600 .cam.env
echo "저장했어요. 결과: tail -f ~/eg2-lab/ipcam.log"
