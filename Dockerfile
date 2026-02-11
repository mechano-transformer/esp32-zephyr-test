FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ZEPHYR_BASE=/opt/zephyrproject/zephyr
ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ENV ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk

# -------------------------
# OS deps
# -------------------------
RUN apt update && apt install -y \
    git cmake ninja-build gperf ccache dfu-util \
    device-tree-compiler wget xz-utils file make \
    gcc gcc-multilib g++-multilib \
    python3 python3-pip python3-venv \
    curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# west
RUN pip3 install --break-system-packages west

# -------------------------
# Zephyr workspace
# -------------------------
WORKDIR /opt
RUN west init -m https://github.com/zephyrproject-rtos/zephyr zephyrproject

WORKDIR /opt/zephyrproject
RUN west update --narrow

# Python deps（公式）
RUN pip3 install --break-system-packages \
    -r $ZEPHYR_BASE/scripts/requirements.txt

# ★ ESP32必須ツール（west packagesの代替）
RUN pip3 install --break-system-packages esptool

RUN west zephyr-export

# SDK
RUN west sdk install --install-dir $ZEPHYR_SDK_INSTALL_DIR

# blobs
RUN west blobs fetch hal_espressif

WORKDIR /workspace
CMD ["/bin/bash"]
