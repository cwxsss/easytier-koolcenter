#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
EasyTier KoolCenter 插件打包脚本
用于将 easytier/ 目录打包为符合 KoolCenter 离线安装标准的 easytier.tar.gz
"""

import os
import sys
import tarfile
import hashlib

# 确保在 Windows 控制台下输出 UTF-8 编码不受 GBK 限制
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

def main():
    base_dir = "easytier"
    tar_name = "easytier.tar.gz"
    md5_name = "easytier.tar.gz.md5"

    if not os.path.isdir(base_dir):
        print(f"[ERROR] 找不到目录 {base_dir}")
        return

    print("========================================")
    print(" 正在打包 EasyTier for KoolCenter ...")
    print("========================================")

    # 规范化文本文件换行符为 Unix LF
    text_extensions = ('.sh', '.js', '.asp', '.conf', '.toml', '.txt')
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            path = os.path.join(root, file)
            if file.endswith(text_extensions) or file.startswith('.'):
                try:
                    with open(path, 'rb') as f:
                        content = f.read()
                    if b'\r\n' in content:
                        content = content.replace(b'\r\n', b'\n')
                        with open(path, 'wb') as f:
                            f.write(content)
                        print(f"[OK] 转换换行符 (CRLF -> LF): {path}")
                except Exception as e:
                    print(f"[WARN] 读取错误: {path}: {e}")

    def filter_tarinfo(tarinfo):
        tarinfo.uid = 0
        tarinfo.gid = 0
        tarinfo.uname = "root"
        tarinfo.gname = "root"
        name = tarinfo.name.replace("\\", "/")
        tarinfo.name = name
        if tarinfo.isdir():
            tarinfo.mode = 0o755
        elif name.endswith(".sh") or "bin/" in name:
            tarinfo.mode = 0o755
        else:
            tarinfo.mode = 0o644
        return tarinfo

    with tarfile.open(tar_name, "w:gz") as tar:
        tar.add(base_dir, arcname="easytier", filter=filter_tarinfo)

    with open(tar_name, "rb") as f:
        md5_val = hashlib.md5(f.read()).hexdigest()

    with open(md5_name, "w") as f:
        f.write(f"{md5_val}  {tar_name}\n")

    size_mb = os.path.getsize(tar_name) / (1024 * 1024)
    print("========================================")
    print(f"[SUCCESS] 打包完成: {tar_name}")
    print(f"[INFO] 文件大小: {size_mb:.2f} MB")
    print(f"[INFO] MD5校验值: {md5_val}")
    print(f"[INFO] MD5记录文件: {md5_name}")
    print("========================================")

if __name__ == "__main__":
    main()
